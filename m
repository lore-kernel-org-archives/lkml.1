Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbZJRSvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbZJRSvn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 14:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755112AbZJRSvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 14:51:42 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34749 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058AbZJRSvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 14:51:42 -0400
Date: Sat, 17 Oct 2009 19:27:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <gregkh@suse.de>
Cc: david@lang.hm, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: removing existing working drivers via staging
Message-ID: <20091017172743.GE1526@ucw.cz>
References: <alpine.DEB.2.00.0910142213590.22169@asgard.lang.hm> <4AD74ED7.9070501@s5r6.in-berlin.de> <alpine.DEB.2.00.0910150936310.22169@asgard.lang.hm> <20091015164726.GA10125@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091015164726.GA10125@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-10-15 09:47:26, Greg KH wrote:
> On Thu, Oct 15, 2009 at 09:39:51AM -0700, david@lang.hm wrote:
> > however, what I think I saw proposed was to move drivers that need to be 
> > 'cleaned up', to staging and then dropping them if they don't get cleaned.
> 
> What is "proposed" is the following:
> 
> 	- For drivers currently in the kernel tree, that the subsystem
> 	  maintainer, for whatever reason, feels is obsolete / broken /
> 	  needs major cleaning / wants to get rid of, can be submitted
> 	  to the staging maintainer to be moved to the drivers/staging/
> 	  directory.
> 	- For a file to be moved into this directory, all of the normal
> 	  staging rules apply, including most importantly, a TODO file
> 	  listing what needs to be done to the driver in order for it to
> 	  be moved back into the main portion of the kernel tree.
> 	- If, after a period of 3 releases, no work has been done on the
> 	  driver by anyone, the driver will be removed from the staging
> 	  tree, just like all drivers in the staging tree.
> 
> Note, as always, if a driver wants to come back from removal of the
> staging tree, a simple email to the staging maintainer, along with the
> promise that work will be done, is all it takes to resurrect it.
> 
> Sound good?
> 
> Now, where to put these "rules"?  Any suggestions?

I'm not sure it sounds good. It should not be named 'staging' at
least.

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
