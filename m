Return-Path: <linux-kernel-owner+w=401wt.eu-S2992613AbXDLQHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992613AbXDLQHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 12:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992610AbXDLQHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 12:07:34 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:31138 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992602AbXDLQHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 12:07:33 -0400
X-IronPort-AV: i="4.14,403,1170662400"; 
   d="scan'208"; a="135050058:sNHT83326311"
To: Steve Wise <swise@opengridcomputing.com>
Cc: Divy Le Ray <divy@chelsio.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Netdev@vger.kernel.org,
       OpenFabrics General <general@lists.openfabrics.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 2.6.21] iw_cxgb3 - Add set_tcb_rpl_handler.
X-Message-Flag: Warning: May contain useful information
References: <1176382594.9396.1.camel@stevo-desktop>
	<461E45C3.2050400@chelsio.com> <adaveg1ipki.fsf@cisco.com>
	<1176392566.9396.11.camel@stevo-desktop>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 12 Apr 2007 09:07:20 -0700
In-Reply-To: <1176392566.9396.11.camel@stevo-desktop> (Steve Wise's message of "Thu, 12 Apr 2007 10:42:46 -0500")
Message-ID: <ada3b35ink7.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Apr 2007 16:07:21.0160 (UTC) FILETIME=[A6A2EC80:01C77D1C]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > The patch is the 3rd of 3:
 > 
 > http://marc.info/?l=linux-kernel&m=117617444622279&w=2
 > 
 > Jeff applied it into his upstream tree here:
 > 
 > http://marc.info/?l=linux-netdev&m=117630664627997&w=2

OK, so it's not in Linus's tree yet.  Jeff, how do you want to handle
this?  (That last patch breaks drivers/infiniband/hw/cxgb3, and Steve
posted a fix to handle it)

The cleanest thing would be for you to roll up Steve's fix into the
patch you merged, so that Linus's tree is never in the state where it
has half the change merged.  But I don't know if that fits your
workflow.

Thanks...
