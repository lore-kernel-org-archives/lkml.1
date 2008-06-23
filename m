Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbYFWSPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbYFWSPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 14:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755366AbYFWSO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 14:14:58 -0400
Received: from wilson.telenet-ops.be ([195.130.132.42]:45179 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503AbYFWSO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 14:14:56 -0400
Date: Mon, 23 Jun 2008 20:14:51 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, paulus@samba.org,
       zippel@linux-m68k.org, linuxppc-dev@ozlabs.org,
       linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] drivers/macintosh/: possible cleanups
In-Reply-To: <20080623174657.GC4756@cs181140183.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0806232014160.20175@anakin>
References: <20080609222312.GM1987@cs181133002.pp.htv.fi>
 <20080610102125.2816c9e3.sfr@canb.auug.org.au> <20080623174657.GC4756@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008, Adrian Bunk wrote:
> On Tue, Jun 10, 2008 at 10:21:25AM +1000, Stephen Rothwell wrote:
> > On Tue, 10 Jun 2008 01:23:12 +0300 Adrian Bunk <bunk@kernel.org> wrote:
> > >
> > > +++ b/drivers/macintosh/adbhid.c
> > > @@ -75,7 +75,7 @@ static struct notifier_block adbhid_adb_notifier = {
> > >  #define ADB_KEY_POWER_OLD	0x7e
> > >  #define ADB_KEY_POWER		0x7f
> > >  
> > > -u16 adb_to_linux_keycodes[128] = {
> > > +static u16 adb_to_linux_keycodes[128] = {
> > 
> > This could be const as well.
> 
> Updated patch below.
> 
> cu
> Adrian
> 
> <--  snip  -->
> 
> This patch contains the following possible cleanups:
> - make the following needlessly global code static:
>   - adb.c: adb_controller
>   - adb.c: adb_init()
>   - adbhid.c: adb_to_linux_keycodes[]  (also make it const)
>   - via-pmu68k.c: backlight_level
>   - via-pmu68k.c: backlight_enabled
> - remove the following unused code:
>   - via-pmu68k.c: sleep_notifier_list
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

I assume Paulus will take it, as he controls more Macs?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
