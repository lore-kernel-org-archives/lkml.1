Return-Path: <linux-kernel-owner+w=401wt.eu-S935870AbZLPWl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935870AbZLPWl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935863AbZLPWls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:41:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:60485 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935868AbZLPWlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:41:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [BISECTED] drm: random hang since 620f378 "drm: prune modes when ..."
Date: Wed, 16 Dec 2009 22:41:27 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.32-07500-g8bea867-dirty; KDE/4.3.2; x86_64; ; )
Cc: Dave Airlie <airlied@redhat.com>, Daniel Vetter <daniel@ffwll.ch>,
       Adam Jackson <ajax@redhat.com>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, keithp@keithp.com, eric@anholt.net,
       Daniel Vetter <daniel.vetter@ffwll.ch>
References: <200912071830.14697.arnd@arndb.de> <20091216133005.0e822950@jbarnes-piketon> <200912162136.36458.arnd@arndb.de>
In-Reply-To: <200912162136.36458.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912162241.27591.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19Yu97TSrWBVv7QOyHEVHJMQUyAin8ubaQ40pW
 INAu8cJebqM/hQ+5axhfH0UsAg9Rdc2WfiaoqQIKagdfS1Lbb4
 TB+wnUm3imk02JsVitSSQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 December 2009 21:36:36 Arnd Bergmann wrote:
> On Wednesday 16 December 2009 21:30:05 Jesse Barnes wrote:
> > But you're sure powersave=0 was solid?  Hmm...
> 
> It's hard to be sure when it sometimes takes a day before a
> broken version crashes. I can keep running this kernel with and
> without powersave=0 some more and tell you if it stays reproducible.

Now it has crashed with i915.powersave=0 plus your patch as well
(latest 2.6.32 git), indicating that there is something else wrong
with the original 652c393a33 patch.

	Arnd
