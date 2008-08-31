Return-Path: <linux-kernel-owner+w=401wt.eu-S1758866AbYHaN2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866AbYHaN2m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 09:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759374AbYHaN2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 09:28:32 -0400
Received: from mail.gmx.net ([213.165.64.20]:58633 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758759AbYHaN2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 09:28:31 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1/pjg4NQJjpBtcC6zwb3jYU0Wkm/AeAkl7X/E396F
	LC8JXaiuHlPG9R
From: Stefan Lippers-Hollmann <s.L-H@gmx.de>
To: Gerhard Brauer <gerhard.brauer@web.de>
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
Date: Sun, 31 Aug 2008 15:28:22 +0200
User-Agent: KMail/1.9.9
Cc: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
References: <20080826141851.GA5300@tux1.brauer.lan> <20080828103013.163730ee@doriath.conectiva> <20080831092923.GB4305@tux1.brauer.lan>
In-Reply-To: <20080831092923.GB4305@tux1.brauer.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808311528.27353.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sonntag, 31. August 2008, Gerhard Brauer wrote:
[...]
> Ok, some news from archlinux side:
> Our distribution kernel was upgraded from 2.6.26.2 to 2.6.26.3. With
> this upgrade to patchlevel .3 the "early oops"(freeing smp...) has gone.
> My virtual machines boots always fine with this, and i have one
> confirmation from a user about this.

Sorry, I can't confirm this here on Debian unstable (with virtualbox-ose 
1.6.2 or 1.6.4), are you sure that other configuration options didn't 
change between the different kernel versions? Preemption and paravirt can
influence the probability of the early boot panic seriously, without really
avoiding it alltogether.

Actually I still get the same issues with implanting
ftp://ftp5.gwdg.de/pub/linux/archlinux/core/os/i686/kernel26-2.6.26.3-1-i686.pkg.tar.gz
into the test vm using virtualbox-ose 1.6.4.

> Kernel upgrade does not solve the kernel panic during work with the VM,
> when there is heavy disk IO. I test and could reproduce this by untar 2
> big files in seperate dirs: bsdtar -x -f VirtualBox-1.6.2-OSE.tar.bz2.
> Doing this simultan crashed the VM always.
> SreenShot:
> http://users.archlinux.de/~gerbra/tmp/2008-08-31-110449_724x456_scrot.png
> 
> This heavy IO oops does not occur under 2.6.26.2 when using the
> "3-changes-patch" against alternatives.c, which we have tested in the
> other mails. There must be something irq related which fix this
> 3-changes-patch, and what was not fixed in 2.6.26.3
> On the other hand: I never have stressed a VM like this before
> researching for this problem. So it could also be that the heavy-IO
> problem way a total seperate problem from that we're talking about here.
> Doing my "normal" work now in VM (it's my devel VM for compiling and
> testing), until now i don't have had this IO oops.
> 
> We use a mostly unpatched kernel as distribution kernel.
> 
> So short summary from my side:
> a) With "3-changes-patch" i got a rock solide VM
> b) 2.6.26.2 have the early oops on boot and IO oops when sometimes
>    bootet.
> c) 2.6.26.3 have only the heavy-IO oops
> 
> I'll try a fresh VM, where i will test:
> a) Using sata controller emulation as bus (now i have ide(piix3))
> b) Using different filesystems (With 2.6.26.2 early oops and heavy-io
>    oops could be reproduced with any filesystem).
> 
> 
> Regards
> 	Gerhard

Regards
	Stefan Lippers-Hollmann
