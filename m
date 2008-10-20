Return-Path: <linux-kernel-owner+w=401wt.eu-S1752203AbYJTAej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbYJTAej (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 20:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751024AbYJTAeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 20:34:31 -0400
Received: from mail.anarazel.de ([217.115.131.40]:52724 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbYJTAeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 20:34:31 -0400
From: Andres Freund <andres@anarazel.de>
To: Keith Packard <keithp@keithp.com>
Subject: Re: [git pull] agp patches for 2.6.28-rc1.
Date: Mon, 20 Oct 2008 02:34:28 +0200
User-Agent: KMail/1.10.1 (Linux/2.6.27-andres-04904-gc813b4e; KDE/4.1.2; x86_64; ; )
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
References: <alpine.DEB.0.82.0810160758320.16504@skynet.skynet.ie> <200810200144.44383.andres@anarazel.de> <1224461977.5303.34.camel@koto.keithp.com>
In-Reply-To: <1224461977.5303.34.camel@koto.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810200234.28751.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 20 October 2008 02:19:37 you wrote:
> The GM45/G45 support in both kernel and user space was horribly broken,
> causing the kernel to either overwrite stolen entries with freshly
> allocated pages, and potentially corrupt the system, or leave some GTT
> entries uninitialized and cause the hardware to lock up.
I had some crashes with 3d, but none in 2d as far as I know.

> You appear to have a happy situation where this bug isn't obviously
> breaking things. We couldn't find any machines where even simple 2D
> graphics was stable for very long.
Interesting. I had the system running for some days without problems related 
to graphics.

> We applied a patch to both kernel and 2D driver (as both end up
> computing the size of the GTT stolen area for historical reasons) to fix
> this mistake. Updating your 2D driver to 2.4.98 should get you the other
> half of the fix.
Ok, will try, and also report this to ubuntu and maybe other distributions...

> Yeah, I'm getting information about how 'hybrid' graphics hardware
> works.
If you need some information/testing/whatever...

Andres
