Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbYHYHYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbYHYHYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 03:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbYHYHXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 03:23:51 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:41471 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751549AbYHYHXu (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 03:23:50 -0400
Date: Mon, 25 Aug 2008 09:23:46 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Will Marone <wjmarone@gmail.com>
cc: Jared Hulbert <jaredeh@gmail.com>, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>, tim.bird@AM.SONY.COM
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
In-Reply-To: <48AF3905.70304@gmail.com>
Message-ID: <Pine.LNX.4.64.0808250922500.3893@vixen.sonytel.be>
References: <48AD00C4.6060302@gmail.com> <Pine.LNX.4.64.0808221650500.17105@vixen.sonytel.be>
 <48AF3905.70304@gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1942548691-1219649026=:3893"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1942548691-1219649026=:3893
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 22 Aug 2008, Will Marone wrote:
> Geert Uytterhoeven wrote:
> > I gave AxFS a try on PS3 (ppc64, always use big-endian 64-bit for testing
> > new
> > code ;-).
> > When mounting the image, I got the crash below:
> >
> > | attempt to access beyond end of device
> > | loop0: rw=0, want=4920, limit=4912
> > | Unable to handle kernel paging request for data at address 0x00000028
> > | Faulting instruction address: 0xd000000000037988
> > | Oops: Kernel access of bad area, sig: 11 [#1]
> > | SMP NR_CPUS=2 PS3
> >
> > When mounting (also on PS3) an image created on ia32, I get a different
> > crash:
> >
> > | axfs: wrong magic
> >   ^^^^^^^^^^^^^^^^^
> > | Unable to handle kernel paging request for data at address 0x000003a8
> > | Faulting instruction address: 0xd0000000000355f0
> > | Oops: Kernel access of bad area, sig: 11 [#1]
> > | SMP NR_CPUS=2 PS
> Geert,
> 
> Thanks for giving it a spin, especially on a platform as different from ours
> as the PS3.
> 
> Before I dig more into what happened, I was wondering if you could tell me a
> bit more
> about your environment, particularly how you supplied the filesystem to the
> kernel and
> your mount commandline (also, if you used a boot commandline, what it was.)
> 
> My first guess would be a ppc64 compiled UML session, but I'd like to be a bit
> more sure.

Nope, I just built axfs as a module and insmoded it. After that

    mount image.axfs /mnt -o loop -t axfs

So nothing fancy.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-1942548691-1219649026=:3893--
