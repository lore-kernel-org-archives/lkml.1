Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbYJTVgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbYJTVgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 17:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbYJTVgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 17:36:22 -0400
Received: from kroah.org ([198.145.64.141]:37435 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753906AbYJTVgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 17:36:21 -0400
Date: Mon, 20 Oct 2008 13:43:18 -0700
From: Greg KH <greg@kroah.com>
To: mtk.manpages@gmail.com
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org
Subject: Re: [PATCH] Document kernel taint flags properly
Message-ID: <20081020204318.GB21131@kroah.com>
References: <20081017225515.GA14133@kroah.com> <cfd18e0f0810180151v232f623pdbf0f12cad6532d6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0810180151v232f623pdbf0f12cad6532d6@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 03:51:11AM -0500, Michael Kerrisk wrote:
> Greg,
> 
> Small corrections below.
> 
> On Fri, Oct 17, 2008 at 5:55 PM, Greg KH <greg@kroah.com> wrote:
> > From: Greg Kroah-Hartman <gregkh@suse.de>
> >
> > This fills in the documentation for all of the current kernel taint
> > flags, and fixes the number for TAINT_CRAP, which was incorrectly
> > described.
> >
> > Cc: Michael Kerrisk <mtk.manpages@gmail.com>
> > Cc: Randy Dunlap <rdunlap@xenotime.net>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> >
> > ---
> >  Documentation/sysctl/kernel.txt |   24 +++++++++++++++++-------
> >  1 file changed, 17 insertions(+), 7 deletions(-)
> >
> > --- a/Documentation/sysctl/kernel.txt
> > +++ b/Documentation/sysctl/kernel.txt
> > @@ -363,11 +363,21 @@ tainted:
> >  Non-zero if the kernel has been tainted.  Numeric values, which
> >  can be ORed together:
> >
> > -  1 - A module with a non-GPL license has been loaded, this
> > -      includes modules with no license.
> > -      Set by modutils >= 2.4.9 and module-init-tools.
> > -  2 - A module was force loaded by insmod -f.
> > -      Set by modutils >= 2.4.9 and module-init-tools.
> > -  4 - Unsafe SMP processors: SMP with CPUs not designed for SMP.
> > - 64 - A module from drivers/staging was loaded.
> > +   1 - A module with a non-GPL license has been loaded, this
> > +       includes modules with no license.
> > +       Set by modutils >= 2.4.9 and module-init-tools.
> > +   2 - A module was force loaded by insmod -f.
> > +       Set by modutils >= 2.4.9 and module-init-tools.
> > +   4 - Unsafe SMP processors: SMP with CPUs not designed for SMP.
> > +   8 - A module was forcefully unloaded from the system by rmmod -f.
> 
> s/forcefully/forcibly/
> 
> > +  16 - A hardware machine check error occured on the system.
> 
> occurred

Thanks, I've updated this in my version.

Randy, I can send this through my tree, is that ok?  Or do you want it
to go through yours?

thanks,

greg k-h
