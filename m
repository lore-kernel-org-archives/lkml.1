Return-Path: <linux-kernel-owner+w=401wt.eu-S1754357AbXINGGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbXINGGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 02:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbXINGGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 02:06:42 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:55498 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbXINGGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 02:06:42 -0400
Date: Fri, 14 Sep 2007 08:08:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dan Aloni <da-x@monatomic.org>, Bernhard Walle <bwalle@suse.de>
Subject: Re: [PATCH] Add ELF note with Linux version
Message-ID: <20070914060805.GA32169@uranus.ravnborg.org>
References: <20070904150018.GA4357@suse.de> <46DFD825.2020109@goop.org> <20070913144228.2efcd5d9.akpm@linux-foundation.org> <20070913221340.GA29181@uranus.ravnborg.org> <46E9BD3D.4050102@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E9BD3D.4050102@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 03:44:13PM -0700, Jeremy Fitzhardinge wrote:
> Sam Ravnborg wrote:
> > I would rather see allt this ELFNOTE stuff reverted.
> > It causes troubles for several archs and is at the moment
> > being discussed at arm-kernel for example.
> >
> > Having it reverted and then applied when it is ready for all archs would
> > be preferred.
> >   
> 
> What problems does it cause on other archs?  It should be
> cross-architecture.
> 
> > On top of this I never understood the actual purpose of it...
> 
> It was originally there to put ELF notes into the vdso objects.  I'm
> using it to create notes in vmlinux for Xen, and apparently people are
> using it to put other metadata into their kernel images.
>From a post on arm-kernel:

> With build-id binutils (e.g. the latest bintuils 2.18), objcopy produces
> a 3.1 Gbytes Image file.

This seems outright silly.
Either we should revert the notes changes or someone caring about it 
should sweep all archs and make sure it does not hurt there.

	Sam
