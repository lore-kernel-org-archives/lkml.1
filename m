Return-Path: <linux-kernel-owner+w=401wt.eu-S1752528AbYCLI5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbYCLI5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 04:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYCLI51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 04:57:27 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4468 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751282AbYCLI50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 04:57:26 -0400
Date: Wed, 12 Mar 2008 09:57:14 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Vivek Goyal <vgoyal@redhat.com>, "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -mm] kexec jump -v9
Message-ID: <20080312085714.GB3993@ucw.cz>
References: <1204773188.4707.109.camel@caritas-dev.intel.com> <20080311211004.GA30164@redhat.com> <20080311232415.GA26320@elf.ucw.cz> <200803120049.06491.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803120049.06491.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > The features of this patch can be used for as follow:
> > > > 
> > > > - A simple hibernation implementation without ACPI support. You can
> > > >   kexec a hibernating kernel, save the memory image of original system
> > > >   and shutdown the system. When resuming, you restore the memory image
> > > >   of original system via ordinary kexec load then jump back.
> > > > 
> > > 
> > > The main usage of this functionality is for hibernation. I am not sure
> > > what has been the conclusion of previous discussions.
> > > 
> > > Rafael/Pavel, does the approach of doing hibernation using a separate
> > > kernel holds promise?
> > 
> > Its certainly "more traditional" method of doing hibernation than
> > tricks swsusp currently plays.
> 
> What exactly are you referring to?

Well, traditionaly it is 'A saves B to disk' (like bootloader saves
kernel&userspace). In swsusp we have 'kernel saves itself'... which
works, too, but is pretty different design.

> > Now, I guess they are some difficulties, like ACPI integration, and
> > some basic drawbacks, like few seconds needed to boot second kernel
> > during suspend.
> > 
> > ...OTOH this is probably only chance to eliminate freezer from
> > swsusp...
> 
> Some facts:
> 
> * There's no reason to think that we can't use this same mechanism for
>   hibernation (the only difficulty seems to be the handling of devices used for
>   saving the image).

Ok, at least kexec makes handling of suspend device easier.

> Moreover, if this had been the _only_ argument for the $subject functionality,
> I'd have been against it.

Fortunately its not the only one :-).

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
