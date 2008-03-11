Return-Path: <linux-kernel-owner+w=401wt.eu-S1752030AbYCKXXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbYCKXXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 19:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750939AbYCKXXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 19:23:43 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45434 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbYCKXXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 19:23:43 -0400
Date: Wed, 12 Mar 2008 00:24:15 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -mm] kexec jump -v9
Message-ID: <20080311232415.GA26320@elf.ucw.cz>
References: <1204773188.4707.109.camel@caritas-dev.intel.com> <20080311211004.GA30164@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080311211004.GA30164@redhat.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > This is a minimal patch with only the essential features. All
> > additional features are split out and can be discussed later. I think
> > it may be easier to get consensus on this minimal patch.
> > 
> 
> Hi Huang,
> 
> This patchset is slowly getting better. True that first we need to come
> up with minimal infrastructure patch and then think of building more
> functionality on top of it.
> 
...
> > The features of this patch can be used for as follow:
> > 
> > - A simple hibernation implementation without ACPI support. You can
> >   kexec a hibernating kernel, save the memory image of original system
> >   and shutdown the system. When resuming, you restore the memory image
> >   of original system via ordinary kexec load then jump back.
> > 
> 
> The main usage of this functionality is for hibernation. I am not sure
> what has been the conclusion of previous discussions.
> 
> Rafael/Pavel, does the approach of doing hibernation using a separate
> kernel holds promise?

Its certainly "more traditional" method of doing hibernation than
tricks swsusp currently plays. Yes, I'd like these patches to go in,
being able to switch kernels seems like useful tool.

Now, I guess they are some difficulties, like ACPI integration, and
some basic drawbacks, like few seconds needed to boot second kernel
during suspend.

...OTOH this is probably only chance to eliminate freezer from
swsusp...

Yes, I'd like to see this to go ahead.

No, this does not make swsusp obsolete just yet.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
