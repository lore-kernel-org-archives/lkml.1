Return-Path: <linux-kernel-owner+w=401wt.eu-S2993033AbXCIHRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993033AbXCIHRD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 02:17:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993037AbXCIHRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 02:17:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:13940 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993033AbXCIHRA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 02:17:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,265,1170662400"; 
   d="scan'208"; a="206469868:sNHT54969908"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 0/2] NET: Multiple queue network device support REPOST
Date: Thu, 8 Mar 2007 23:16:58 -0800
Message-ID: <D5C1322C3E673F459512FB59E0DDC329026E982F@orsmsx414.amr.corp.intel.com>
In-Reply-To: <20070308.231142.74749203.davem@davemloft.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 0/2] NET: Multiple queue network device support REPOST
thread-index: AcdiGj+6k8FYat3jRVOPwDiTG1w2KAAAC0OA
From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
To: "David Miller" <davem@davemloft.net>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       "Leech, Christopher" <christopher.leech@intel.com>
X-OriginalArrivalTime: 09 Mar 2007 07:16:59.0171 (UTC) FILETIME=[ED353F30:01C7621A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This is not a problem.
> 
> Since the ->enqueue function stores references to the SKBs, 
> any change of the dev->qdisc has to flush those references 
> somehow, and it is at that point that you can fixup the skb 
> queue mappings.
> 
> This happens via invoking the qdisc->ops->reset() method.
> 

Thanks Dave.  It seems expensive to change all the skb's if this type of
event occurs, but I suppose it is a corner case and can be tolerated.
Please let me make this change and I'll resubmit.

Also, the first patch set was RFC, and you were the only one to submit
feedback to me.  :-/  So I figured submitting as an official patch for
feedback might get more attention.

And to reiterate what Auke asked, what did happen to the patches?  I see
things getting through the netdev mailing list, but they're not showing
up on www.spinics.net/lists/netdev.  Was it something I did when
sending, or did majordomo hiccup?

Thanks,

-PJ Waskiewicz
