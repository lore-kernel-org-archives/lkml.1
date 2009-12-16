Return-Path: <linux-kernel-owner+w=401wt.eu-S1759217AbZLPNxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217AbZLPNxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 08:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758140AbZLPNxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 08:53:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51423 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757562AbZLPNxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 08:53:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [BISECTED] drm: random hang since 620f378 "drm: prune modes when ..."
Date: Wed, 16 Dec 2009 14:53:11 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Dave Airlie <airlied@redhat.com>, Daniel Vetter <daniel@ffwll.ch>,
       Adam Jackson <ajax@redhat.com>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, keithp@keithp.com, eric@anholt.net,
       Daniel Vetter <daniel.vetter@ffwll.ch>
References: <200912071830.14697.arnd@arndb.de> <20091214125024.77601d7e@jbarnes-piketon> <200912151051.44131.arnd@arndb.de>
In-Reply-To: <200912151051.44131.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912161453.12100.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/66/f34W2K7PZ3I8nanUio21oUJTVIE/LRd6B
 u727DhfM6NcRJpvwUSuNZWTEdjxYhRgrpE/p+kmTb+rZI2l8mr
 4x2/n8dFxzFOiLyK0THKg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 December 2009, Arnd Bergmann wrote:
> On Monday 14 December 2009, Jesse Barnes wrote:
> > This patch removes the suspect portion of the dynamic clock control
> > code.  Hopefully it'll be as stable as powersave=0 in your config
> > (assuming powersave=0 works :).
> 
> Ok, great! The machine is still running  fine with powersave=0 so 
> far. I'll try your patch after some more uptime.

It's working fine so far, no more crashes, but I supposed this effectively
disables the power saving on my card again, right?

I should probably mention that this machine has had stability problems
before and showed single-bit memory corruption, but that problem
has disappeared after I installed bigger CPU and northbridge coolers
and increased the voltage slightly.

	Arnd
