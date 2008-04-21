Return-Path: <linux-kernel-owner+w=401wt.eu-S1762222AbYDUOXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762222AbYDUOXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 10:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758822AbYDUOXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 10:23:16 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:53054 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757963AbYDUOXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 10:23:15 -0400
Date: Mon, 21 Apr 2008 17:22:45 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jiri Kosina <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
Subject: Re: [PATCH 29/37] Input: fix ordering in joystick Makefile
Message-ID: <20080421142245.GI6011@cs181133002.pp.htv.fi>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com> <1b8930dc64b6842e50711441ba67482aacc475dd.1208783694.git.dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1b8930dc64b6842e50711441ba67482aacc475dd.1208783694.git.dmitry.torokhov@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 01:43:05PM +0100, Jiri Kosina wrote:
> Make entries in drivers/input/joystick/Makefile properly alphabetically
> ordered.

It also adds an entry for CONFIG_JOYSTICK_MAPLE?

BTW: The From: and To: headers in your emails were not correct.

> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
>  drivers/input/joystick/Makefile |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/joystick/Makefile b/drivers/input/joystick/Makefile
> index 868b746..e262840 100644
> --- a/drivers/input/joystick/Makefile
> +++ b/drivers/input/joystick/Makefile
> @@ -15,9 +15,11 @@ obj-$(CONFIG_JOYSTICK_GF2K)		+= gf2k.o
>  obj-$(CONFIG_JOYSTICK_GRIP)		+= grip.o
>  obj-$(CONFIG_JOYSTICK_GRIP_MP)		+= grip_mp.o
>  obj-$(CONFIG_JOYSTICK_GUILLEMOT)	+= guillemot.o
> +obj-$(CONFIG_JOYSTICK_IFORCE)		+= iforce/
>  obj-$(CONFIG_JOYSTICK_INTERACT)		+= interact.o
>  obj-$(CONFIG_JOYSTICK_JOYDUMP)		+= joydump.o
>  obj-$(CONFIG_JOYSTICK_MAGELLAN)		+= magellan.o
> +obj-$(CONFIG_JOYSTICK_MAPLE)		+= maplecontrol.o
>  obj-$(CONFIG_JOYSTICK_SIDEWINDER)	+= sidewinder.o
>  obj-$(CONFIG_JOYSTICK_SPACEBALL)	+= spaceball.o
>  obj-$(CONFIG_JOYSTICK_SPACEORB)		+= spaceorb.o
> @@ -29,4 +31,3 @@ obj-$(CONFIG_JOYSTICK_WARRIOR)		+= warrior.o
>  obj-$(CONFIG_JOYSTICK_XPAD)		+= xpad.o
>  obj-$(CONFIG_JOYSTICK_ZHENHUA)		+= zhenhua.o
>  
> -obj-$(CONFIG_JOYSTICK_IFORCE)		+= iforce/
> -- 
> 1.5.5.rc2.6.gf58d
> 
