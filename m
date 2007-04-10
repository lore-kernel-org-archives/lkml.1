Return-Path: <linux-kernel-owner+w=401wt.eu-S1753329AbXDJVms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbXDJVms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753682AbXDJVms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:42:48 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:23714 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbXDJVmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:42:46 -0400
X-IronPort-AV: i="4.14,391,1170662400"; 
   d="scan'208"; a="134163601:sNHT44159166"
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Milind Arun Choudhary <milindchoudhary@gmail.com>,
       kernel-janitors@lists.osdl.org, kernelnewbies@nl.linux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [KJ]remove SPIN_LOCK_UNLOCKED
X-Message-Flag: Warning: May contain useful information
References: <20070410181654.GA10525@arun.site>
	<Pine.LNX.4.61.0704102249290.32056@yvahk01.tjqt.qr>
	<Pine.LNX.4.64.0704101722030.24526@CPE00045a9c397f-CM001225dbafb6>
	<Pine.LNX.4.61.0704102327460.32056@yvahk01.tjqt.qr>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 10 Apr 2007 14:42:38 -0700
In-Reply-To: <Pine.LNX.4.61.0704102327460.32056@yvahk01.tjqt.qr> (Jan Engelhardt's message of "Tue, 10 Apr 2007 23:28:11 +0200 (MEST)")
Message-ID: <ada7isjq52p.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Apr 2007 21:42:38.0579 (UTC) FILETIME=[28B9F430:01C77BB9]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > >but that's where you would use the more explicit
 > >__RAW_SPIN_LOCK_UNLOCKED, no?  AFAIK, you really can remove the macro
 > >SPIN_LOCK_UNLOCKED in its entirety.
 > 
 > I don't remember LDD speaking about __RAW_*. (And other than not
 > having looked into the code to date, I don't know the difference.)

Don't worry about the __RAW_SPIN_LOCK_UNLOCKED stuff, that's obviously
not for generic code to use.  The right answer (as I said before) is
to use DEFINE_SPINLOCK().

 - R.
