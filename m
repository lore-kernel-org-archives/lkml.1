Return-Path: <linux-kernel-owner+w=401wt.eu-S1757261AbYFZITa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbYFZITa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 04:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756830AbYFZISq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 04:18:46 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2567 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756712AbYFZISk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 04:18:40 -0400
Date: Tue, 24 Jun 2008 20:21:33 +0200
From: Pavel Machek <pavel@suse.cz>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>,
       Al Viro <viro@zeniv.linux.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: "r/o bind mounts" patch in 2.6.26-rc6 changes (breaks?) error behaviour
Message-ID: <20080624182132.GH5642@ucw.cz>
References: <485B8361.6010708@LiPPERTEmbedded.de> <1213971466.7512.17.camel@nimitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213971466.7512.17.camel@nimitz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-06-20 07:17:46, Dave Hansen wrote:
> On Fri, 2008-06-20 at 12:16 +0200, Jens Rottmann wrote:
> > 
> > I noticed the following change in the error behaviour when attempting
> > to delete nonexisting files/dirs from R/O-mounted directories:
> > 
> > Linux 2.6.25.7:
> > rm /RO_mounted_path/nonexisting_file
> > ==> "No such file or directory"
> > 
> > Linux 2.6.26-rc6-git6:
> > rm /RO_mounted_path/nonexisting_file
> > ==> "Read-only file system"
> 
> We looked at this way back in the beginning when I started to work on
> the patches.  It was decided that the error codes weren't horribly
> important.  We did have a case a bit ago where it really mattered, and
> Al fixed that up.
> 
> I know this changed behavior a bit, but userspace can surely work around
> it with read-only operations (stat) when it is really important to get
> the error to the user just right.

I'd say userspace should not have to work around this.

Interface change, in stable series, w/o deprecation period, new
interface is worse than the old one...

						Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
