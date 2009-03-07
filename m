Return-Path: <linux-kernel-owner+w=401wt.eu-S1756376AbZCGVGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbZCGVGT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 16:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbZCGVGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 16:06:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60241 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755500AbZCGVGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 16:06:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: 2.6.29-rc breaks STD using Intel 945
Date: Sat, 7 Mar 2009 22:05:48 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc7-tst; KDE/4.2.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
       dri-devel@lists.sourceforge.net,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <200903042020.57671.eike-kernel@sf-tec.de>
In-Reply-To: <200903042020.57671.eike-kernel@sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903072205.48658.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 March 2009, Rolf Eike Beer wrote:
> Hi,
> 
> I tested several snapshots post 2.6.28 and all of them show one severe 
> problem: resume from disk is not always successful. Only about 50% of the 
> resume attempts work, in the other cases I just get a completely black 
> screen, can't switch to text console or anything. What I often get is a line 
> like this in the logs directly before suspend:
> 
> [drm:i915_get_vblank_counter] *ERROR* trying to get vblank count for disabled 
> pipe 0
> 
> Afterwards I find nothing in the logs. Switching back to 2.6.28 and everything 
> works fine again. I have a Toshiba A110-178 running openSuSE 11.1 32 bit with 
> KDE 4.2.0. I upgraded my Xserver from 1.5 to 1.6 yesterday but that did not 
> change anything. The only external module I use is the omnibook module 
> (http://sf.net/projects/omnibook) which I've been using for years without any 
> problems.
> 
> VGA device is this:
> 
> 00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS, 
> 943/940GML Express Integrated Graphics Controller (rev 03) (prog-if 00 [VGA 
> controller])
>         Subsystem: Toshiba America Info Systems Device ff01
>         Flags: bus master, fast devsel, latency 0, IRQ 16
>         Memory at dc100000 (32-bit, non-prefetchable) [size=512K]
>         I/O ports at 1800 [size=8]
>         Memory at c0000000 (32-bit, prefetchable) [size=256M]
>         Memory at dc200000 (32-bit, non-prefetchable) [size=256K]
>         Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- 
> Count=1/1 Enable-
>         Capabilities: [d0] Power Management version 2
>         Kernel modules: intelfb
> 
> 00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML 
> Express Integrated Graphics Controller (rev 03)
>         Subsystem: Toshiba America Info Systems Device ff01
>         Flags: bus master, fast devsel, latency 0
>         Memory at dc180000 (32-bit, non-prefetchable) [size=512K]
>         Capabilities: [d0] Power Management version 2
> 
> If you have any patches you want to try me or have any further questions just 
> mail me. If you're hanging around at CeBIT I can come over and we can discuss 
> this in person as I'm there for the next days anyway.

What version of the Intel X driver are you using?

Rafael
