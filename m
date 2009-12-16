Return-Path: <linux-kernel-owner+w=401wt.eu-S932329AbZLPVVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbZLPVVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 16:21:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932215AbZLPVVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 16:21:14 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:57192 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210AbZLPVVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 16:21:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [BISECTED] drm: random hang since 620f378 "drm: prune modes when ..."
Date: Wed, 16 Dec 2009 21:20:34 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.32-07500-g8bea867-dirty; KDE/4.3.2; x86_64; ; )
Cc: Dave Airlie <airlied@redhat.com>, Daniel Vetter <daniel@ffwll.ch>,
       Adam Jackson <ajax@redhat.com>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, keithp@keithp.com, eric@anholt.net,
       Daniel Vetter <daniel.vetter@ffwll.ch>
References: <200912071830.14697.arnd@arndb.de> <200912161453.12100.arnd@arndb.de> <20091216121823.08b5f0a6@jbarnes-piketon>
In-Reply-To: <20091216121823.08b5f0a6@jbarnes-piketon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912162120.34163.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19g1YcjeLXhJMEZDQWkg0MI92QUDYCxDOVeWPF
 HuU+bJwgFbrtYxCnedJrecxGMGDhnPDiMmqcJ2fXiAN+uzH6uc
 skpeW1BGFHViMOgdnecjw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 December 2009 20:18:23 Jesse Barnes wrote:
> On Wed, 16 Dec 2009 14:53:11 +0100
> Arnd Bergmann <arnd@arndb.de> wrote:
>
> > It's working fine so far, no more crashes, but I supposed this
> > effectively disables the power saving on my card again, right?
> 
> The patch just disables one (probably ineffective) power saving
> feature.  So if things are working well for you with it I'll queue up a
> revert patch.  I'm working on a better version of dynamic clock control
> anyway.

It just crashed again after a few hours of uptime with some unrelated
reboots in-between, with your patch applied.

The symptom was slightly different, now the whole screen was filled
with random patterns, not just parts of the screen. Aside from that, it
was just the same complete lockup as without the patch. Possibly less
frequent, but that's hard to tell after a single sample.

	Arnd
