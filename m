Return-Path: <linux-kernel-owner+w=401wt.eu-S934443AbZJJRvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934443AbZJJRvL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 13:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933829AbZJJRvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 13:51:08 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:12935 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933898AbZJJRvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 13:51:07 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAGxm0EqrR7Ht/2dsb2JhbADAAJdihC0E
X-IronPort-AV: E=Sophos;i="4.44,538,1249257600"; 
   d="scan'208";a="406257740"
From: Roland Dreier <rdreier@cisco.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Thomas Schlichter <thomas.schlichter@web.de>, linux-kernel@vger.kernel.org,
       Thomas Hellstrom <thellstrom@vmware.com>
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not available
References: <200910100322.36857.thomas.schlichter@web.de>
	<4AD00C89.3000503@linux.intel.com>
	<200910101031.15620.thomas.schlichter@web.de>
	<4AD0ABFF.1020209@linux.intel.com>
X-Message-Flag: Warning: May contain useful information
Date: Sat, 10 Oct 2009 10:50:29 -0700
In-Reply-To: <4AD0ABFF.1020209@linux.intel.com> (Arjan van de Ven's message of
	"Sat, 10 Oct 2009 08:45:03 -0700")
Message-ID: <adazl7zi1ei.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Oct 2009 17:50:29.0611 (UTC) FILETIME=[27F99BB0:01CA49D2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > > Hmm, my CPU (VIA Nano) seems to support PAT, but Ubuntu disables this
 > > feature in its kernel config. I'm using 9.04, but even 9.10 will have PAT
 > > disabled:
 > 
 > that sounds like a bad idea. But to each distro their own I suppose.

Seems that Ubuntu has caught this issue, and it will probably be
resolved: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/446480

 - R.
