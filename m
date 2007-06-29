Return-Path: <linux-kernel-owner+w=401wt.eu-S933092AbXF2PBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092AbXF2PBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 11:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759699AbXF2PBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 11:01:42 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:47423 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759077AbXF2PBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 11:01:41 -0400
To: mista.tapas@gmx.net
CC: bunk@stusta.de, nix@esperi.org.uk, galibert@pobox.com, tiwai@suse.de,
       kloczek@rudy.mif.pg.gda.pl, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
In-reply-to: <200706291352.42833.mista.tapas@gmx.net> (message from Florian
	Schmidt on Fri, 29 Jun 2007 13:52:42 +0200)
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
References: <20070624200837.16e11305@the-village.bc.nu> <87tzssextf.fsf@hades.wkstn.nix> <20070628210614.GC6087@stusta.de> <200706291352.42833.mista.tapas@gmx.net>
Message-Id: <E1I4HtE-0003A5-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 29 Jun 2007 16:56:05 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I suppose the best way to provide OSS emu is to use something like
> FUSD [similar to the OSS2JACK package] [1] to provide the OSS device
> files and then redirect to user space, so all ALSA pcm devices can
> be used.. Sadly FUSD doesn't really get actively developed anymore
> it seems. And FUSE can't handle ioctls.

Not as if it would be hard to add ioctl support to fuse.  What fuse
can't handle is the data argument of ioctl(), so the most it could do
is give the filesystem a pid (tid) and a virtual address.  The
userspace fs could then get/put the data through /proc/<pid>/mem.

Miklos
