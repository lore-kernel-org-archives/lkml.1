Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbYDWKbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbYDWKbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 06:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbYDWKbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 06:31:10 -0400
Received: from mga14.intel.com ([143.182.124.37]:44832 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434AbYDWKbJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 06:31:09 -0400
X-Greylist: delayed 605 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Apr 2008 06:31:09 EDT
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,698,1199692800"; 
   d="scan'208";a="236561074"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: mac80211/wme.c: check-after-use
Date: Wed, 23 Apr 2008 13:20:35 +0300
Message-ID: <1879838866982C46A9CB3D56BA49ADEB04CCF8FB@hasmsx411.ger.corp.intel.com>
In-Reply-To: <20080423095101.GV28933@cs181133002.pp.htv.fi>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: mac80211/wme.c: check-after-use
Thread-Index: AcilJ73VkZ62RiNYSva57iSD/bP95QAA5oTA
References: <20080423095101.GV28933@cs181133002.pp.htv.fi>
From: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
To: "Adrian Bunk" <bunk@kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 23 Apr 2008 10:20:36.0748 (UTC) FILETIME=[ABF954C0:01C8A52B]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The Coverity checker spotted the following check-after-use of the 
> 
>        u32 len = qdisc->q.qlen;    <------
>
>        if (!qdisc || !qdisc->dequeue)
>                return;

Yep, this is a left over, I'll fix it
Thanks
Ron

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

