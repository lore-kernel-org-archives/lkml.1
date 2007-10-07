Return-Path: <linux-kernel-owner+w=401wt.eu-S1752902AbXJGP3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbXJGP3t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 11:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbXJGP3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 11:29:41 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:48407 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbXJGP3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 11:29:40 -0400
Date: Sun, 7 Oct 2007 17:29:39 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Valdis.Kletnieks@vt.edu, Oleg Verych <olecom@flower.upol.cz>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: NAK nettiquete (was Re: "Re: [PATCH 0/2] Colored kernel output
 (run2)"
In-Reply-To: <20071007161222.1b758f2f@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0710071722010.16301@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr>
 <20071006195105.GE22435@flower.upol.cz> <20071006194820.GA30579@elte.hu>
 <20071006210349.GG22435@flower.upol.cz> <20071007060706.GA18768@elte.hu>
 <20071007111035.GO22435@flower.upol.cz> <2614.1191766530@turing-police.cc.vt.edu>
 <20071007161222.1b758f2f@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 7 2007 16:12, Alan Cox wrote:
>
>- We run on a lot more than VGA PC consoles
>- We have serial consoles (which may or may not be VT132/ANSI compliant)

Yes, and the serial driver does not usually pass on vc->vc_color to the real
hardware. If it did, it would have to transform it back into an unportable
ANSI code and send that. So we don't do that.

>- The printk paths are run at IRQ time ASAP to get messages to console,
>that could mean we split existing colour escape code processing and the
>like.

Oleg already persuaded me to add options to toally configure it out,
so there is no impact for you.

>- People redirect the console feed other places via ioctl. Some of them
>parse "<%d>" as the start

Interestingly enough, the <n> part is not transferred over serial,
but that seems another story.

>- If you want to do "pretty" boot up you do it in X or frame buffer
>(which is going to get easier and easier with the X shift to kernel side
>video support)

fb is slow. Feels like a 9600bps serial line.

Let everyone have his own fun.
