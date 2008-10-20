Return-Path: <linux-kernel-owner+w=401wt.eu-S1752349AbYJTBAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbYJTBAY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 21:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbYJTBAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 21:00:11 -0400
Received: from mail.anarazel.de ([217.115.131.40]:57875 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbYJTBAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 21:00:10 -0400
From: Andres Freund <andres@anarazel.de>
To: Keith Packard <keithp@keithp.com>
Subject: Re: [git pull] agp patches for 2.6.28-rc1.
Date: Mon, 20 Oct 2008 03:00:01 +0200
User-Agent: KMail/1.10.1 (Linux/2.6.27-andres-04904-gc813b4e; KDE/4.1.2; x86_64; ; )
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
References: <alpine.DEB.0.82.0810160758320.16504@skynet.skynet.ie> <200810200144.44383.andres@anarazel.de> <1224461977.5303.34.camel@koto.keithp.com>
In-Reply-To: <1224461977.5303.34.camel@koto.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810200300.01411.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 October 2008 02:19:37 Keith Packard wrote:
> On Mon, 2008-10-20 at 01:44 +0200, Andres Freund wrote:
> > Hi Dave,
> >
> > On Monday 20 October 2008 01:25:22 Dave Airlie wrote:
> > > What type of laptop is it and what GPU has it.
> > > if distros are carrying GM45 supporting stuff we might be in trouble..
>
> The GM45/G45 support in both kernel and user space was horribly broken,
> causing the kernel to either overwrite stolen entries with freshly
> allocated pages, and potentially corrupt the system, or leave some GTT
> entries uninitialized and cause the hardware to lock up.
>
> You appear to have a happy situation where this bug isn't obviously
> breaking things. We couldn't find any machines where even simple 2D
> graphics was stable for very long.
>
> We applied a patch to both kernel and 2D driver (as both end up
> computing the size of the GTT stolen area for historical reasons) to fix
> this mistake. Updating your 2D driver to 2.4.98 should get you the other
> half of the fix.
Hm. But still, there is at least one distribution (ubuntu intrepid) which will 
propably will ship 2.4.1 in its stable version soon (it seems unlikely that 
they will update to an unstable version just before an release).
Which means, that this driver will get quite some spread...
Is it accepted that the kernel abi breaks that radically/fast?

Andres
