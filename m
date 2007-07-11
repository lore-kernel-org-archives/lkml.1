Return-Path: <linux-kernel-owner+w=401wt.eu-S937159AbXGLAEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937159AbXGLAEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935753AbXGKXoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:44:16 -0400
Received: from mail.suse.de ([195.135.220.2]:34523 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935692AbXGKXoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:44:15 -0400
Date: Wed, 11 Jul 2007 16:43:11 -0700
From: Greg KH <gregkh@suse.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 01/61] Rules on how to use sysfs in userspace programs
Message-ID: <20070711234311.GA6437@suse.de>
References: <20070711233021.GA5253@kroah.com> <11841967403365-git-send-email-gregkh@suse.de> <Pine.LNX.4.64.0707111937040.30342@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707111937040.30342@localhost.localdomain>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 07:38:59PM -0400, Robert P. J. Day wrote:
> On Wed, 11 Jul 2007, Greg Kroah-Hartman wrote:
> 
> > From: Kay Sievers <kay.sievers@vrfy.org>
> >
> > Here's a document to help clear things up.
> >
> > Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > ---
> >  Documentation/sysfs-rules.txt |  166 +++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 166 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/sysfs-rules.txt
> >
> > diff --git a/Documentation/sysfs-rules.txt b/Documentation/sysfs-rules.txt
> > new file mode 100644
> > index 0000000..42861bb
> > --- /dev/null
> > +++ b/Documentation/sysfs-rules.txt
> > @@ -0,0 +1,166 @@
> > +Rules on how to access information in the Linux kernel sysfs
> > +
> > +The kernel exported sysfs exports internal kernel implementation-details
>        kernel-exported                               implementation details
> > +and depends on internal kernel structures and layout. It is agreed upon
> > +by the kernel developers that the Linux kernel does not provide a stable
> > +internal API. As sysfs is a direct export of kernel internal
> > +structures, the sysfs interface can not provide a stable interface eighter,
>                                                                       either
> ...
> 
> you might want to hold off on that patch for a few minutes.  :-)

Patches for grammer are always accepted :)

Care to make up one against Linus's tree after this goes in?

thanks,

greg k-h
