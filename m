Return-Path: <linux-kernel-owner+w=401wt.eu-S1755311AbYL2L6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbYL2L6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 06:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbYL2L62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 06:58:28 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:50155 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbYL2L61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 06:58:27 -0500
Date: Mon, 29 Dec 2008 13:00:02 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] headers_check.pl: disallow extern's
Message-ID: <20081229120002.GB955@uranus.ravnborg.org>
References: <1230363816-24097-1-git-send-email-vapier@gentoo.org> <20081227184355.GA9264@uranus.ravnborg.org> <20081227185415.GA10361@uranus.ravnborg.org> <200812290515.09121.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812290515.09121.vapier@gentoo.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2008 at 05:15:08AM -0500, Mike Frysinger wrote:
> On Saturday 27 December 2008 13:54:15 Sam Ravnborg wrote:
> > > And we need to get these fixed before we apply this patch.
> > > Otherwise we will break every allyesconfig/allmodconfig builds
> >
> > I turned them into warnings for now.
> > And when I was there I fixed the TODO:
> >
> > From 2bbc376f97c4a75fbbb603b34f73db235a8cd2c1 Mon Sep 17 00:00:00 2001
> > From: Sam Ravnborg <sam@ravnborg.org>
> > Date: Sat, 27 Dec 2008 19:52:20 +0100
> > Subject: [PATCH] kbuild: check for leaked CONFIG_ symbols to userspace
> 
> btw, do you maintain these in a git tree somewhere, or you just posting them 
> to lkml ?  the two kbuild trees under your name on kernel.org/git seems to be 
> lacking this change.  i was looking at adding another check: barf if the 
> header uses __[us]{8,16,32,64} types but does not include linux/types.h.

I push regurlary to kbuild-next.git but you hit a window where I had
asked Linus to pull and thus I avoided any updates.

I the meantime I managed to delete the patches I had queued up so
I need to do a bit of digging before I have a fully updated
kbuild-next.git again.

	Sam
