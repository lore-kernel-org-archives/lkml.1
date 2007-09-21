Return-Path: <linux-kernel-owner+w=401wt.eu-S1765582AbXIUVNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765582AbXIUVNw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 17:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763177AbXIUVNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 17:13:41 -0400
Received: from mail.fieldses.org ([66.93.2.214]:32914 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763104AbXIUVNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 17:13:40 -0400
Date: Fri, 21 Sep 2007 17:13:38 -0400
To: Nix <nix@esperi.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.22.6] nfsd: fh_verify() `malloc failure' with lots of
	free memory leads to NFS hang
Message-ID: <20070921211338.GF1951@fieldses.org>
References: <874phtkk25.fsf@hades.wkstn.nix> <20070917223600.GA30350@fieldses.org> <87zlzkkfvk.fsf@hades.wkstn.nix> <20070918011257.GC2443@fieldses.org> <873ax7ua9j.fsf@hades.wkstn.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <873ax7ua9j.fsf@hades.wkstn.nix>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 07:46:32PM +0100, Nix wrote:
> On 18 Sep 2007, J. Bruce Fields told this:
> > Also I suppose we should check which version of nfs-utils that fix is in
> > and make sure distributions are getting the fixed nfs-utils before they
> > get the new libc, or we're going to see this bug a lot....
> 
> Further info. This behaviour, although it is allowed by POSIX, is not
> *specified*, as such, by it (ah! ambiguity! life would be so dull
> without you!), and is not replicated by any other C library on the face
> of the planet.
> 
> Further, it's not even the behaviour of glibc, as such.
> 
> It's the behaviour of glibc 2.6.x as patched with this Debian-specific
> patch:

Good grief.  Well, I'd still count it as a bug in nfs-utils, then, but
nfs-util's share of the blame is much less than we'd previously
thought....

> This patch also breaks at least bash and zsh as well as nfs-utils (see
> <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=429021>) and I sort of
> suspect it's not long for this world as a result.
> 
> So this is much less nasty than we feared (well, and more nasty if you
> happen to be a Debian unstable or testing user).

OK!  Sounds like good news.

--b.
