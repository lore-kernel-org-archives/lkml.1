Return-Path: <linux-kernel-owner+w=401wt.eu-S1758756AbZJMCI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbZJMCI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 22:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758744AbZJMCI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 22:08:56 -0400
Received: from keil-draco.com ([216.193.185.50]:48061 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758738AbZJMCIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 22:08:55 -0400
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Oct 2009 22:08:55 EDT
From: Daniel Hazelton <dhazelton@enter.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
Date: Mon, 12 Oct 2009 22:00:17 -0400
User-Agent: KMail/1.12.2 (Linux/2.6.28-15-generic; KDE/4.3.2; x86_64; ; )
Cc: Nix <nix@esperi.org.uk>, "Justin P. Mattock" <justinmattock@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Boyan <btanastasov@yahoo.co.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       " =?iso-8859-1?q?Fr=E9d=E9ric_L=2E_W=2E?= Meunier" 
	<fredlwm@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <87ljjgfcbu.fsf@spindle.srvr.nix> <20091013003841.6c2988d0@lxorguk.ukuu.org.uk>
In-Reply-To: <20091013003841.6c2988d0@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910122200.18064.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 October 2009 07:38:41 pm Alan Cox wrote:
> > So it seems likely to me that this is a kernel bug, somewhere, and the
> > TTY layer seems like a good place to look (OK, a horrible place, but a
> > *likely* place).
> 
> Somewhere around 2.6.29-30 various things went funny in the keyboard
> layer for me - notably characters "bleeding" across console switches.

Possibly not even related... I was seeing a similar problem in .26 or so and 
it turned out to be caused, IIRC, by SCIM (in Gnome) and the KDE "Input 
Methods" system. However my problem might not be related, because this even 
stopped Alt-SysRq-K from working - and it only happened if I was holding down 
a "modifier key" for a longer than average (say 30 seconds). I never reported 
this because I soon after got tired of that distro (I was giving it a try at 
the urging of friends) and replaced it.

The problem has not re-occurred since.

DRH
