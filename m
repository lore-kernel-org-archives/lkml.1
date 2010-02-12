Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab0BLSym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 13:54:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60321 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756991Ab0BLSyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 13:54:41 -0500
Date: Fri, 12 Feb 2010 10:47:56 -0800
From: Greg KH <gregkh@suse.de>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/1] Staging: hv: Add proper versioning to HV
 drivers-Corrected.
Message-ID: <20100212184756.GA14751@suse.de>
References: <8AFC7968D54FB448A30D8F38F259C56212E883CB@TK5EX14MBXC118.redmond.corp.microsoft.com>
 <20100211233612.GB10315@suse.de>
 <8AFC7968D54FB448A30D8F38F259C56212E88B0F@TK5EX14MBXC118.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C56212E88B0F@TK5EX14MBXC118.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 05:55:34PM +0000, Hank Janssen wrote:
> 
> > >
> > >  drivers/staging/hv/VersionInfo.h |   22 +++++++++++++++++++---
> > 
> > You forgot a "---" between the signed-off-by and the diffstat.  If you
> > use either git or quilt, it will get this correct automagically.  That
> > infers you used something else, which is quite scary.  What are you
> > using instead to create patches?
> > 
> > Don't worry, I can edit this by hand when I apply it, and will do so in
> > a few days when I get to my "to-apply" queue, but in the future, please
> > don't do this.
> > 
> > thanks,
> > 
> > greg k-h
> 
> This must have been the result of a cut/paste error on my side.
> 
> I use the following command for my diff   'git diff -M -u --stat'

What's wrong with 'git format-patch'?

You are creating a "raw" diff, which is fine, but you then need to
include the rest of the comments.  If you commit the patch to a branch,
with the comments in them, then you can just automatically create the
patches in correct format.

> Btw, it was my understanding that the -M flag allows tracking of renamed 
> files as well as part of the diff output. (git mv) But my diff command 
> does not report on those.  Am I doing something wrong?

You aren't renaming anything :)

Also, don't do that for patches you send through emails, quilt can not
handle them properly, which is what I require for the patches sent to
me.  When I queue them up to Linus, git properly figures out renames and
the like, so you don't need to worry about that.

thanks,

greg k-h
