Return-Path: <linux-kernel-owner+w=401wt.eu-S933160AbXBEUSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160AbXBEUSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 15:18:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933253AbXBEUSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 15:18:46 -0500
Received: from mail-relay-2.tiscali.it ([213.205.33.42]:34738 "EHLO
	mail-relay-2.tiscali.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933160AbXBEUSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 15:18:45 -0500
Date: Mon, 5 Feb 2007 21:18:24 +0100
From: Luca Tettamanti <kronos@people.it>
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
Message-ID: <20070205201824.GA13431@dreamland.darkstar.lan>
References: <ephv35$4i3$1@sea.gmane.org> <20070128160831.fb51347f.akpm@osdl.org> <21d7e9970701281612q56b694edp6efd1a5556dea3fe@mail.gmail.com> <20070128162907.370f5476.akpm@osdl.org> <21d7e9970701281639w57edc2efw4ba620d4c1bdcee7@mail.gmail.com> <cb7bb73a0701290637q2ce0ff16t28f82d0c0339a2ba@mail.gmail.com> <20070130203301.GA15067@dreamland.darkstar.lan> <20070204201713.GA12867@dreamland.darkstar.lan> <cb7bb73a0702041317u4ca2fbabp45cf56526e57c982@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cb7bb73a0702041317u4ca2fbabp45cf56526e57c982@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il Sun, Feb 04, 2007 at 10:17:08PM +0100, Giuseppe Bilotta ha scritto: 
> On 2/4/07, Luca Tettamanti <kronos@people.it> wrote:
> >Giuseppe, can you send me the EDID block of your monitor?
> 
> I'd gladly do it, if I knew how to retrieve it ... because apparently,
> get-edid doesn't work, even though both the nv driver for X and
> nvidiafb manage to retrieve it.

get-edid uses the BIOS, while the other two talk directly over the I2C
bus.

Try loading i2c-dev (I2C_CHARDEV); With i2cdump[1] you can read the EDID
block, which resides at address 0x50:

i2cdump N 0x50 (where N is the bus number)

If you are unshure about bus number try with all the available
/dev/i2c-* devices (you may want to unload HW monitor drivers first, so
you don't poke at random stuff).

Luca
[1] lm-sensors package, at least on Debian.
-- 
La somma dell'intelligenza sulla terra è una costante.
La popolazione è in aumento.
