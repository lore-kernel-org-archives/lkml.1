Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbYCXXkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbYCXXkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 19:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYCXXj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 19:39:58 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:43389 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbYCXXj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 19:39:57 -0400
Date: Mon, 24 Mar 2008 19:39:52 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Catalin Marinas <catalin.marinas@gmail.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, git <git@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Stacked GIT 0.14.2
Message-ID: <20080324233952.GD32221@josefsipek.net>
References: <b0943d9e0803241259s5280cdc1o255a4412b3fa7bfc@mail.gmail.com> <alpine.LNX.1.10.0803242113070.9368@fbirervta.pbzchgretzou.qr> <b0943d9e0803241624ne83602emc1fb4727402555d3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0943d9e0803241624ne83602emc1fb4727402555d3@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2008 at 11:24:20PM +0000, Catalin Marinas wrote:
> On 24/03/2008, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> > On Monday 2008-03-24 20:59, Catalin Marinas wrote:
> >
> >  > Stacked GIT 0.14.2 release is available from http://www.procode.org/stgit/.
> >  >
> >  > StGIT is a Python application providing similar functionality to Quilt
> >  > (i.e. pushing/popping patches to/from a stack) on top of GIT.
> >
> >
> > I always wondered what the difference between stgit and guilt is.
> >  Does anyone have a comparison up?
> 
> There was a thread last year:
> 
> http://kerneltrap.org/mailarchive/git/2007/6/14/249310
> 
> I don't follow the guilt development to be able to comment. They are
> pretty similar regarding patch management but it's probably best to
> try both and see which tool you like. StGIT might have a few more
> features as it was around for longer (e-mail templates, patch
> synchronisation between branches etc.) but guilt seems actively
> developed as well.
 
Right. Try both and use whatever you're happier with.

> I might be wrong here but I'm not sure whether guilt uses three-way
> merging when pushing a patch or just a two-way diff apply. The
> three-way merging has several advantages in dealing with conflicts.

It's still using two-way diff apply, but I'd like to implement a three-way
merge as a fallback.

Josef 'Jeff' Sipek.

-- 
The box said "Windows XP or better required". So I installed Linux.
