Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbXKYWkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbXKYWkc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 17:40:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756648AbXKYWkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:40:24 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38066 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756040AbXKYWkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:40:23 -0500
Date: Sun, 25 Nov 2007 23:40:10 +0100
From: Adrian Bunk <bunk@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: kernel bugzilla is FPOS (was: Re: "buggy cmd640" message
	followed by soft lockup)
Message-ID: <20071125224010.GA5006@stusta.de>
References: <200711222007.12497.elendil@planet.nl> <200711252228.07312.rjw@sisk.pl> <20071125213640.GC18284@stusta.de> <200711252339.00557.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200711252339.00557.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 25, 2007 at 11:38:59PM +0100, Rafael J. Wysocki wrote:
> On Sunday, 25 of November 2007, Adrian Bunk wrote:
> > On Sun, Nov 25, 2007 at 10:28:06PM +0100, Rafael J. Wysocki wrote:
> > > On Sunday, 25 of November 2007, Adrian Bunk wrote:
> > >..
> > > > First of all, Bugzilla is a quite often used bug tracker in the open 
> > > > source world [1], so many users already know it.
> > > > 
> > > > But more important, "it pretends to require them to spend" isn't true 
> > > > because there's no pretending - we actually often require bug reporters 
> > > > to spend a lot of time on the bug report (e.g. when asking for 
> > > > bisecting).
> > > 
> > > But not *initially*.
> > > 
> > > We should not confuse *debugging* with *reporting bugs*.  While the former is
> > > actually more difficult and more time consuming than writing the code in which
> > > the bug is present, the latter should be as simple as sending an email.
> > 
> > For hardcore geeks like you and me sending an email might be easier than 
> > using some web interface.
> > 
> > Normal humans tend to be more accustomed to web interfaces, and 
> > following the instructions on some web page is _much_ easier than 
> > reading three text files for knowing what to write in an email.
> 
> Hm, this is a good argument for having such a web interface, but IMO it
> shouldn't be mandatory.  IOW, there should be a way to report a bug using plain
> email, if the reporter prefers that.  We can, however, request that the address
> of our bug tracking system be added to the report's Cc list.

Looking at both other open source projects and the support of commercial 
software a web interface should be enough.

But this is not the problem - the problem is what happens after the 
initial report with the bug report.

> Now, the question is what information this web interface should ask for.
> 
> IMO, first, it should ask for what the bug is against, ie.:
> - kernel version (to be obtained from 'git describe' or from /proc/version or
>   from .config, if the kernel doesn't boot)
> - architecture (x86, ARM, MIPS etc.)
> - subsystem and subsubsystem (that could be selectable from a menu and might
>   depend on the architecture)
> 
> It also should ask if the problem is a regression and what was the last known
> good kernel (I'd prefer that to be the last known major release selectable from
> a list).
> 
> Also, the reporter should be required to provide a summary (subject) and
> a (concise) description of the problem and a list of email addresses to
> send the report to in addition to the regular handling (there should be a way
> to verify which addresses are acceptable).
> 
> Anything else?
> 
> Next, the report should be sent to a mailing list selected on the basis of the
> information provided (not necessarily to individual developers, unless there
> are some addresses provided explicitly by the reporter).

The architecture choice seems to be the only thing from your list that
isn't already available in the "Enter a new bug report" dialog of the
kernel Bugzilla.

> IMO, it should be possible to work on the bug using both email and the web
> interface, whichever is preferred by the participant in question, without the
> need to stick to any of them (ie. email messages sent in the corresponding
> email thread should be registered by the bug tracking system and comments
> entered into it should appear as messages in the email thread with the
> appropriate To:, From: and Cc: information).
> 
> There surely are more things that we'd like it to do, but the above seem to be
> a reasonable minimum.

Except from the From: header in outgoing emails the kernel Bugzilla 
already offers this for years.

>...
> Greetings,
> Rafael

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

