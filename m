Return-Path: <linux-kernel-owner+w=401wt.eu-S1422793AbXBGX5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422793AbXBGX5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 18:57:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422821AbXBGX5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 18:57:35 -0500
Received: from jack.tiscali.it ([213.205.33.53]:33282 "EHLO jack.tiscali.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422793AbXBGX5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 18:57:34 -0500
Date: Thu, 8 Feb 2007 00:57:28 +0100
From: Luca Tettamanti <kronos@people.it>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: Andrew Morton <akpm@osdl.org>, Dave Airlie <airlied@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
Message-ID: <20070207235728.GA28695@dreamland.darkstar.lan>
References: <20070128160831.fb51347f.akpm@osdl.org> <21d7e9970701281612q56b694edp6efd1a5556dea3fe@mail.gmail.com> <20070128162907.370f5476.akpm@osdl.org> <21d7e9970701281639w57edc2efw4ba620d4c1bdcee7@mail.gmail.com> <cb7bb73a0701290637q2ce0ff16t28f82d0c0339a2ba@mail.gmail.com> <20070130203301.GA15067@dreamland.darkstar.lan> <20070204201713.GA12867@dreamland.darkstar.lan> <cb7bb73a0702041317u4ca2fbabp45cf56526e57c982@mail.gmail.com> <20070205201824.GA13431@dreamland.darkstar.lan> <cb7bb73a0702051328n50c889d9o461ac2bb9f9ea75e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb7bb73a0702051328n50c889d9o461ac2bb9f9ea75e@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il Mon, Feb 05, 2007 at 10:28:36PM +0100, Giuseppe Bilotta ha scritto: 
> On 2/5/07, Luca Tettamanti <kronos@people.it> wrote:
> > get-edid uses the BIOS, while the other two talk directly over the I2C
> > bus.
> >
> > Try loading i2c-dev (I2C_CHARDEV); With i2cdump[1] you can read the EDID
> > block, which resides at address 0x50:
> >
> > i2cdump N 0x50 (where N is the bus number)
> >
> > If you are unshure about bus number try with all the available
> > /dev/i2c-* devices (you may want to unload HW monitor drivers first, so
> > you don't poke at random stuff).
[...]
> There is no such thing as /dev/i2c* UNLESS I load nvidiafb.

Of course :)

> When I
> load that, I get three busses (i2c-0, -1, and -2), but i2cdump N 0x50
> gives me a nice tableau of X's all around, for all values of N.

There may be a bug in the serial clock line control, at least the code
looks strange. I'll check and come back with a patch ASAP.

Luca
-- 
"Sei l'unica donna della mia vita".
(Adamo)
