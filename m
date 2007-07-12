Return-Path: <linux-kernel-owner+w=401wt.eu-S932594AbXGLWP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594AbXGLWP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 18:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761412AbXGLWPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 18:15:08 -0400
Received: from ns.suse.de ([195.135.220.2]:59468 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761861AbXGLWPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 18:15:06 -0400
Date: Thu, 12 Jul 2007 15:14:02 -0700
From: Greg KH <gregkh@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 01/61] Rules on how to use sysfs in userspace programs
Message-ID: <20070712221402.GA30182@suse.de>
References: <20070711233021.GA5253@kroah.com> <11841967403365-git-send-email-gregkh@suse.de> <20070712084846.GA1882@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070712084846.GA1882@elf.ucw.cz>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 10:48:46AM +0200, Pavel Machek wrote:
> On Wed 2007-07-11 16:31:20, Greg Kroah-Hartman wrote:
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
> > +and depends on internal kernel structures and layout. It is agreed upon
> > +by the kernel developers that the Linux kernel does not provide a stable
> > +internal API. As sysfs is a direct export of kernel internal
> > +structures, the sysfs interface can not provide a stable interface eighter,
> > +it may always change along with internal kernel changes.
> 
> It is also agreed upon by the kernel developers that the Linux kernel
> does have a stable user<->kernel API... so we have a small problem
> here. 

I agree, that is why we have described the proper ways to use /sys in a
manner that is acceptable to future changes in it.

> Maybe solution is to declare /sys unstable, but... perhaps /sys can
> stop mirroring internal structures? I do not think we should codify
> our failure to keep /sys stable here.

I think that /sys is to valuable to say it can just never be used by
userspace programs.  With these suggestions, do you see any problems
with any potential future changes in the layout that you can come up
with?

thanks,

greg k-h
