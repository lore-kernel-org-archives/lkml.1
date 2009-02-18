Return-Path: <linux-kernel-owner+w=401wt.eu-S1762248AbZBRWw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762248AbZBRWw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761867AbZBRWud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:50:33 -0500
Received: from smtp4.ono.com ([62.42.230.177]:52584 "EHLO resmaa15.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758599AbZBRWub convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:50:31 -0500
Date: Wed, 18 Feb 2009 23:50:22 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Intel driver vs MTRRs conflict
Message-ID: <20090218235022.1b5aba55@one.home>
In-Reply-To: <499B64DC.2060600@zytor.com>
References: <20090218002046.55c17814@werewolf.home>
 <499B64DC.2060600@zytor.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.4; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Feb 2009 17:31:08 -0800, "H. Peter Anvin" <hpa@zytor.com> wrote:

> J.A. Magallón wrote:
> > 
> > As I said, everything works. And even fast for the kind of machine, it's an
> > Aspire One and gears gives 740 fps, and video playback is pretty smooth.
> > But perhaps it would be faster if X could get that mtrr it claims ?
> > 
>

Sorry for the delay...
 
> Which CPU?
> 

Atom N270, 1.60GHz, hyperthreaded. 512Kb cache

I have realized that I boot with video=intelfb:mtrr,ywrap.
Could this be interferring ?

Things in syslog I think are relevant:

Feb 17 23:45:47 one klogd: x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Feb 17 23:45:47 one klogd: original variable MTRRs
Feb 17 23:45:47 one klogd: reg 0, base: 4194176KB, range: 128KB, type WP
Feb 17 23:45:47 one klogd: reg 1, base: 4194048KB, range: 128KB, type UC
Feb 17 23:45:47 one klogd: reg 2, base: 0GB, range: 256MB, type WB
Feb 17 23:45:47 one klogd: reg 3, base: 256MB, range: 256MB, type WB
Feb 17 23:45:47 one klogd: reg 4, base: 504MB, range: 8MB, type UC
Feb 17 23:45:47 one klogd: reg 5, base: 502MB, range: 2MB, type UC
Feb 17 23:45:47 one klogd: reg 6, base: 501MB, range: 1MB, type UC
Feb 17 23:45:47 one klogd: reg 7, base: 0GB, range: 128KB, type UC
Feb 17 23:45:47 one klogd: total RAM coverred: 501M
Feb 17 23:45:47 one klogd: Found optimal setting for mtrr clean up
Feb 17 23:45:47 one klogd:  gran_size: 64K ^Ichunk_size: 16M ^Inum_reg: 4  ^Ilose cover RAM: 0G
Feb 17 23:45:47 one klogd: New variable MTRRs
Feb 17 23:45:47 one klogd: reg 0, base: 0GB, range: 512MB, type WB
Feb 17 23:45:47 one klogd: reg 1, base: 501MB, range: 1MB, type UC
Feb 17 23:45:47 one klogd: reg 2, base: 502MB, range: 2MB, type UC
Feb 17 23:45:47 one klogd: reg 3, base: 504MB, range: 8MB, type UC
Feb 17 23:45:47 one klogd: x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Feb 17 23:45:47 one klogd: kernel direct mapping tables up to 1f500000 @ 7000-c000
...
Feb 17 23:45:47 one klogd: vesafb: framebuffer at 0x20000000, mapped to 0xdfd80000, using 1875k, total 7872k
Feb 17 23:45:47 one klogd: vesafb: mode is 800x600x16, linelength=1600, pages=7
Feb 17 23:45:47 one klogd: vesafb: scrolling: redraw
Feb 17 23:45:47 one klogd: vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Feb 17 23:45:47 one klogd: Console: switching to colour frame buffer device 100x37
Feb 17 23:45:47 one klogd: fb0: VESA VGA frame buffer device


-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.1 (Cooker) for x86_64
Linux 2.6.27.5-desktop-1mnb (gcc 4.3.2 (GCC) #1 Sun Nov
