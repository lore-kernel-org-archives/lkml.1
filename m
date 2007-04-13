Return-Path: <linux-kernel-owner+w=401wt.eu-S1752826AbXDOJhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbXDOJhO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 05:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbXDOJhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 05:37:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1073 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752826AbXDOJhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 05:37:12 -0400
Date: Fri, 13 Apr 2007 15:59:50 +0000
From: Pavel Machek <pavel@ucw.cz>
To: David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>, Zhang Rui <rui.zhang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, lenb@kernel.org,
       "linux-acpi@vger" <linux-acpi@vger.kernel.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.21-rc5-git] make /proc/acpi/wakeup more useful
Message-ID: <20070413155949.GA9157@ucw.cz>
References: <200704031741.42273.david-b@pacbell.net> <200704060843.30723.david-b@pacbell.net> <20070407050131.GB25511@kroah.com> <200704071308.07571.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704071308.07571.david-b@pacbell.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Are you _sure_ you have a 1-to-1 relationship here?  No multiple devices
> > pointing to the same acpi node?  Or the other way around?  If so, you
> > are going to have to change the name to be something more unique.
> 
> I've wondered that too.  The short answer:  APCI only supports 1-1
> here.  It will emit warnings if it tries to bind more than one ACPI
...
> Assuming they all adopt that same "parallel tree" model, that seems
> like a good idea.  The tools will likely need to understand how ACPI
> and OF differ, but there's no point in reserving more names than we
> really need.  Though it may be that "parallel trees" should go away.

If mapping is indeed 1-to-1 in acpi... it would be nice to just merge
the trees.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
