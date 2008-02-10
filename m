Return-Path: <linux-kernel-owner+w=401wt.eu-S1756683AbYBJVdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbYBJVdW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 16:33:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbYBJVdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 16:33:04 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:23025 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbYBJVdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 16:33:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wBmozkSd/Zoj3bMYED1M94XGwxF45KL8umBWxupuXKaT5x/3S+JOO7g2pZSkCfo/YqAzhJvoUYXfiWGlFs52NBbftxsJT8vYH+ORzh6RFDxdzLaxFi8rVj2Jrf5ufbN4JhWeKt1wP86YF0F7ijzltAB+po+oosJFhCWfkpbzRAs=
Message-ID: <29495f1d0802101332p6b39b331ye2f6fb488b63e228@mail.gmail.com>
Date: Sun, 10 Feb 2008 13:32:58 -0800
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Subject: Re: 2.6.26-git0: IDE oops during boot
Cc: "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>,
       "Pavel Machek" <pavel@ucw.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
In-Reply-To: <200802071501.09318.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080206105334.GA3664@elf.ucw.cz>
	 <200802062105.42929.bzolnier@gmail.com>
	 <47AAD0CB.3090305@linux.vnet.ibm.com>
	 <200802071501.09318.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/7/08, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
>
> On Thursday 07 February 2008, Kamalesh Babulal wrote:
> > Bartlomiej Zolnierkiewicz wrote:
> > > Hi,
> > >
> > > On Wednesday 06 February 2008, Pavel Machek wrote:
> > >> On Wed 2008-02-06 11:53:34, Pavel Machek wrote:
> > >>> Hi!
> > >>>
> > >>> Trying to boot 2.6.25-git0 (few days old), I get
> > >>>
> > >>> BUG: unable to handle kernel paging request at ffff..ffb0
> > >>> IP at init_irq+0x42e
> > >
> > > init_irq? hmm...
> > >
> > >>> Call trace:
> > >>> ide_device_add_all
> > >
> > > this comes from ide-generic
> > > (Generic IDE host driver)
> > >
> > >>> ide_generic_init
> > >>> kernel_init
> > >>> child_rip
> > >>> vgacon_cursor
> > >>> kernel_init
> > >>> child_rip
> > >>>
> > >>> Excerpt from config:
> > >>>
> > >>> CONFIG_IDE=y
> > >>> CONFIG_BLK_DEV_IDE=y
> > >> Disabling CONFIG_IDE made my machine boot, as it was using libata
> > >> anyway.
> > >
> > > Kamalesh/Pavel:
> > >
> > > Could you try latest git and see if the OOPS is still there?
> > >
> > > [ Yeah, I'm unable to reproduce it. :( ]
> > >
> > > Thanks,
> > > Bart
> > Hi Bart,
> >
> > The panic is reproducible with the 2.6.24-git16 kernel, the call trace is
> > similar to the previous one
>
> Thanks, I again reviewed ide-probe.c changes but nothing seems wrong...
>
> Could you please bisect it down to the guilty commit?

Kamalesh, were you able to bisect this down? I just got hit by the
same panic on a 4-way x86_64, with 2.6.24-git22.

Thanks,
Nish
