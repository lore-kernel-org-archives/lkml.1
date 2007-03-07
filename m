Return-Path: <linux-kernel-owner+w=401wt.eu-S965330AbXCGNLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965330AbXCGNLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 08:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965337AbXCGNLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 08:11:37 -0500
Received: from nz-out-0506.google.com ([64.233.162.235]:37733 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965330AbXCGNLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 08:11:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=Y2jVYJNJKxZfObYZ8Xa+rRmot1e7CLz/YjBCXFfpD8QY6CYYf9WXSyiMsxoUakgVMlYQUGminTk5JA4DzbG8bTzXlQ6cVCBaWjuE9LrozET+tzenVL/pZq8nZ/YPPjywQfpCOPd3dyRE9+ydurxM/R/l5pCq4Mn83+0RgIWT4mo=
Message-ID: <45EEB99D.7020406@googlemail.com>
Date: Wed, 07 Mar 2007 14:09:49 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tim Waugh <tim@cyberelk.net>, linux-parport@lists.infradead.org
Subject: Re: Linux v2.6.21-rc3
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds napisał(a):
> We've finally hopefully started to put a dent in the regressions, 
> especially the suspend/resume problems introduced since 2.6.20.
> 
> So 2.6.21-rc3 is out there now, and there's some hope that it will work 
> more widely than -rc1 and -rc2 did. Please do give it a good testing, and 
> update Adrian and the mailing list (and me) about any regressions 
> (hopefully many more of the "it's fixed now" than other kinds, but all 
> regressions are interesting).
> 
> The appended shortlog gives a reasonable overview. In general we're 
> definitely calming down, and most of the changes are fairly small and 
> obvious fixes. 
> 
> Let's keep the fixes to a minimum, especially since I'm planning on biting 
> peoples heads off if I get any more pull requests for things that aren't 
> real and obvious fixes. 
> 
> 		Linus

BTW. Does anyone care about parport console?
console=lp0 hangs since at least 2.6.18

Calling initcall 0xc0438939: pty_init+0x0/0x231()
Calling initcall 0xc0439235: lp_init_module+0x0/0x238()
lp: driver loaded but no devices found
Calling initcall 0xc043947f: mod_init+0x0/0x286()
intel_rng: FWH not detected
Calling initcall 0xc0439aa9: serial8250_init+0x0/0x114()
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
PM: Adding info for platform:serial8250
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
PM: Adding info for No Bus:ttyS0
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
PM: Adding info for No Bus:ttyS1
PM: Adding info for No Bus:ttyS2
PM: Adding info for No Bus:ttyS3
Calling initcall 0xc0439c6c: serial8250_pnp_init+0x0/0xf()
PM: Removing info for No Bus:ttyS0
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
PM: Adding info for No Bus:ttyS0
PM: Removing info for No Bus:ttyS1
00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
PM: Adding info for No Bus:ttyS1
Calling initcall 0xc0439c7b: serial8250_pci_init+0x0/0x16()
Calling initcall 0xc043a16d: parport_default_proc_register+0x0/0x16()
Calling initcall 0xc043a250: parport_pc_init+0x0/0x196()
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
lp0: using parport0 (interrupt-driven).

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc3/git-config

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
