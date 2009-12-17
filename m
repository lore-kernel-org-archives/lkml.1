Return-Path: <linux-kernel-owner+w=401wt.eu-S1765213AbZLQRwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765213AbZLQRwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 12:52:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764867AbZLQRwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 12:52:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51052 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763022AbZLQRwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 12:52:40 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [BISECTED] drm: random hang since 620f378 "drm: prune modes when ..."
Date: Thu, 17 Dec 2009 18:52:02 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: keithp@keithp.com, Daniel Vetter <daniel.vetter@ffwll.ch>,
       linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
       dri-devel@lists.sourceforge.net
References: <200912071830.14697.arnd@arndb.de> <200912162241.27591.arnd@arndb.de> <20091217092523.755ecf29@jbarnes-piketon>
In-Reply-To: <20091217092523.755ecf29@jbarnes-piketon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912171852.02906.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+ZbFDuYY8/gFze09NwK7LAvLMIPI4VKXleIaX
 5donPI+TelekyOVVH2xwha9gu0Cd48UyeTA46gC5DMqOmZNuqx
 s9y+CH6ZpHFz20BAhxS9w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 December 2009, Jesse Barnes wrote:
> It does very little else that should affect things.  You're sure
> reverting the commit makes things ok?

No, not sure. But I've been running the kernel before that commit
for days without ever seeing a crash. 2.6.31 (also without that
commit but otherwise pretty similar) has been stable for weeks
weeks on the same box.

Once any given kernel version crashes, which can take up to
a day while I'm waiting for the bug to show up, it will typically
crash on that same kernel again within seconds after boot,
just to annoy me and prevent me from using that kernel for
other things.

> Other potential problems:
>   - clock gating (the call to intel_init_clock_gating)
>   - the actual mark_busy stuff itself (calls to intel_mark_busy)
>   - intel_idle_update (but powersave=0 should prevent that)
> 
> If you want to keep testing you could try removing those calls...

Ok, I'll try that. The problem is keeping me from doing any useful
upstream kernel work on my main machine, so I'm rather motivated ;-)

	Arnd
