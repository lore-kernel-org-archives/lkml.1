Return-Path: <linux-kernel-owner+w=401wt.eu-S1756421AbZJ2Ue7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421AbZJ2Ue7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 16:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbZJ2Ue7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 16:34:59 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46233 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbZJ2Ue6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 16:34:58 -0400
Date: Thu, 29 Oct 2009 21:35:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: symlinks with permissions (fwd)
Message-ID: <20091029203500.GB30747@elf.ucw.cz>
References: <20091028211040.GA4182@elf.ucw.cz>
 <4AE922F9.5020506@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE922F9.5020506@schaufler-ca.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> Do you know of any cases where this difference matters in practice?
> >>     
> >
> > Actually yes, see the bugtraq post. guest was able to write to my file
> > when I expected that file to be protected.
> >
> > According to the bugtraq discussion, people expect directory
> > permissions to work.
> 
> Gawd, I hate to say this, but people have been improperly educated
> if they expect directory permissions to behave thusly. You can not
> count on the permissions on a directory to protect access on a file
> that the directory contains a reference to. Hard links. Mount points.
> /proc/8675309/fd. Passing file descriptors over sockets. Fork, for
> heaven's sake. That's not how Linux directories really work.

Actually it was how Unix directories really worked, before Linux /proc
came around and broke it.

See the bugtraq; yes, hardlinks are similar, but at least you see them
on ls -l. Mount points are root-only. And you can't use fork to
upgrade "read-only" filedescriptor to read write. 

										Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
