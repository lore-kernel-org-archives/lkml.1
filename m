Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbYHJXaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbYHJXaA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 19:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYHJX3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 19:29:52 -0400
Received: from relay03.mail-hub.dodo.com.au ([123.2.6.238]:43409 "EHLO
	relay03.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751546AbYHJX3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 19:29:51 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: "Oliver Pinter" <oliver.pntr@gmail.com>
Cc: "Grant Coady" <gcoady.lk@gmail.com>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Krzysztof Halasa" <khc@pm.waw.pl>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] cleanup Serial ATA and Parallel ATA Kconfig try4
Date: Mon, 11 Aug 2008 09:29:22 +1000
Organization: http://bugsplatter.id.au/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <7buu94lnul9v7olc4e0h28qq3gvv6f9s0u@4ax.com>
References: <alpine.LFD.1.10.0808081911080.3254@localhost.localdomain> <20080809103331.1d475d5c@lxorguk.ukuu.org.uk> <m3zlnm75u1.fsf@maximus.localdomain> <20080809141028.14db9bc7@lxorguk.ukuu.org.uk> <m3skteuhod.fsf@maximus.localdomain> <20080809215918.32f25c4b@lxorguk.ukuu.org.uk> <nifs94lqm5a3qjr3rm2p9mks5tad33cbmi@4ax.com> <cu4t94hi8ei77t57vbmc9am4f2bpsrjtrh@4ax.com> <em9t94trh139dvqdva2tlhu7h3ghsijrbm@4ax.com> <6101e8c40808100457w50a907e5na9f3851f6798a433@mail.gmail.com>
In-Reply-To: <6101e8c40808100457w50a907e5na9f3851f6798a433@mail.gmail.com>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Aug 2008 13:57:43 +0200, "Oliver Pinter" <oliver.pntr@gmail.com> wrote:

>Hi Grant!
>
>in ATA_PIIX-s help text is a little "old", and not contained the
>ich9/10s "help text"
...
>> +	  This option enables support for ICH5/6/7/8 Serial ATA <<--
>
>-->>  This option enables support for ICH5/6/7/8/9/10 Serial ATA<<--

Perhaps:

--- linux-2.6.27-rc2f/drivers/ata/Kconfig~	2008-08-10 19:21:48.941431196 +1000
+++ linux-2.6.27-rc2f/drivers/ata/Kconfig	2008-08-11 09:25:34.408822659 +1000
@@ -346,7 +346,7 @@
 	tristate "Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support"
 	depends on PCI && (ATA_SFF_PATA || ATA_SFF_SATA)
 	help
-	  This option enables support for ICH5/6/7/8 Serial ATA
+	  This option enables support for ICH5 or later Serial ATA,
 	  and support for PATA on the Intel ESB/ICH/PIIX3/PIIX4 series
 	  host controllers.
 
So we don't have to edit the thing every six months?

Grant.
