Return-Path: <linux-kernel-owner+w=401wt.eu-S1761094AbYHEMYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761094AbYHEMYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 08:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758781AbYHEMYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 08:24:38 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:53956 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756969AbYHEMYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 08:24:37 -0400
Date: Tue, 5 Aug 2008 15:23:15 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: sonic.zhang@analog.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: serial/bfin_5xx.c build error
Message-ID: <20080805122315.GB25371@cs181140183.pp.htv.fi>
References: <20080802181624.GQ19682@cs181140183.pp.htv.fi> <386072610808042058lf994767qd4c941d8dc13d7c8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <386072610808042058lf994767qd4c941d8dc13d7c8@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 11:58:44AM +0800, Bryan Wu wrote:
> On Sun, Aug 3, 2008 at 2:16 AM, Adrian Bunk <bunk@kernel.org> wrote:
> > Seems to be broken by Alan's changes:
> >
> 
> I'm trying to locate the Alan's change, do you know it, Adrian?
> 
> > <--  snip  -->
> >
> > ...
> >  CC      drivers/serial/bfin_5xx.o
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/bfin_5xx.c: In function 'bfin_serial_set_ldisc':
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/bfin_5xx.c:820: error: 'struct tty_ldisc' has no member named 'num'
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/bfin_5xx.c: In function 'bfin_serial_console_write':
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/bfin_5xx.c:1001: warning: comparison of distinct pointer types lacks a cast
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/bfin_5xx.c:1003: warning: comparison of distinct pointer types lacks a cast
> > make[3]: *** [drivers/serial/bfin_5xx.o] Error 1
> >
> > <--  snip  -->
> 
> So is this bug in mainline upstream or linux-next latest tree?

It was a bug in the mainline upstream kernel.

Alan fixed it with comit b1cbefe5d5fc2d4a6109961d914027172ce8e152 
(blackfin: Fix compile failure in tty code) that went into
Linus' tree last night.

> Thanks
> -Bryan

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

