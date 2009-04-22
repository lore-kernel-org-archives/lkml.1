Return-Path: <linux-kernel-owner+w=401wt.eu-S1756233AbZDVU1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbZDVU1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 16:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbZDVU1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 16:27:04 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50863 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbZDVU1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 16:27:03 -0400
Date: Wed, 22 Apr 2009 22:30:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       randy.dunlap@oracle.com, torvalds@linux-foundation.org, akpm@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] MAINTAINERS - add script, patterns and misc
	updates
Message-ID: <20090422203005.GA467@elf.ucw.cz>
References: <1239167872-8179-1-git-send-email-joe@perches.com> <20090417134711.ba0f03e7.randy.dunlap@oracle.com> <1240003652.31116.44.camel@localhost> <20090407081312.GH1408@ucw.cz> <1240415689.21848.19.camel@localhost> <20090422185916.GA3864@uranus.ravnborg.org> <20090422120510.cc17e470.akpm@linux-foundation.org> <1240430185.21848.103.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240430185.21848.103.camel@localhost>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-04-22 12:56:25, Joe Perches wrote:
> On Wed, 2009-04-22 at 12:05 -0700, Andrew Morton wrote:
> > > It is irritating to manually copy name+email as it looks today.
> > > I always have to do that for the Cc: lines.
> > me2
> 
> This seems to do a decent job of conversion:
> I have this in my tree.  I'll submit it later.
> 
> perl -i -e 'local $/; while(<>) { s@P:	([^\n]+)\nM:	([^\n]+)\n@M:	\1 <\2>\n@g; print; }' MAINTAINERS 

It did not work for here, and I don't understand perl well enough. If
possible, it would be nice to aggregate multiple entries onto one
line. I.e.:

P:      Len Brown
M:      len.brown@intel.com
P:      Pavel Machek
M:      pavel@ucw.cz
P:      Rafael J. Wysocki
M:      rjw@sisk.pl
L:      linux-pm@lists.linux-foundation.org
S:      Supported

->

P:      Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Rafael J. Wysocki <rjw@sisk.pl>
L:      linux-pm@lists.linux-foundation.org
S:      Supported

...
Thanks for your work!
									Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
