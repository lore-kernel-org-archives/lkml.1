Return-Path: <linux-kernel-owner+w=401wt.eu-S1030680AbXDJV0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030680AbXDJV0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030687AbXDJV0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:26:45 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:44141 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030680AbXDJV0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:26:44 -0400
X-Originating-Ip: 74.109.98.130
Date: Tue, 10 Apr 2007 17:25:16 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: Milind Arun Choudhary <milindchoudhary@gmail.com>,
       kernel-janitors@lists.osdl.org, kernelnewbies@nl.linux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [KJ]remove SPIN_LOCK_UNLOCKED
In-Reply-To: <Pine.LNX.4.61.0704102249290.32056@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.64.0704101722030.24526@CPE00045a9c397f-CM001225dbafb6>
References: <20070410181654.GA10525@arun.site> <Pine.LNX.4.61.0704102249290.32056@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2007, Jan Engelhardt wrote:

>
> On Apr 10 2007 23:46, Milind Arun Choudhary wrote:
>
> >"use spin_lock_init instead of SPIN_LOCK_UNLOCKED"
>
> Fact is, we cannot remove SPIN_LOCK_UNLOCKED. It's needed for
> variables outside functions:
>
> static spinlock_t foobar = SPIN_LOCK_UNLOCKED;

but that's where you would use the more explicit
__RAW_SPIN_LOCK_UNLOCKED, no?  AFAIK, you really can remove the macro
SPIN_LOCK_UNLOCKED in its entirety.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
