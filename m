Return-Path: <linux-kernel-owner+w=401wt.eu-S1759422AbXHUNu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759422AbXHUNu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 09:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755284AbXHUNuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 09:50:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59379 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753344AbXHUNuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 09:50:13 -0400
Date: Tue, 21 Aug 2007 12:14:04 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: david@lang.hm, nigel@nigel.suspend2.net,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: [linux-pm] Re: [PATH 1/1] Kexec jump - v2 - kexec jump
Message-ID: <20070821101404.GA1704@elf.ucw.cz>
References: <1184483639.1898.99.camel@caritas-dev.intel.com> <20070731095101.GA1774@elf.ucw.cz> <1185954978.1363.23.camel@caritas-dev.intel.com> <20070816102635.GA2039@elf.ucw.cz> <1187331349.28497.9.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187331349.28497.9.camel@caritas-dev.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> On Thu, 2007-08-16 at 12:26 +0200, Pavel Machek wrote:
> > Ping... is there some next version?
> > 
> > I'm stuck at the tools side currently. kexec-1.101 just won't load the
> > kernel properly, and kexec-testing from git does not know -j option. I
> > tried hand-patching it, but got lots of scary rejects.
> > 
> > Is there chance for a patch against kexec-testing?
> 
> I have some other work to do recently. So the next version will delay
> for some while. :(

Ok, I got it to work -- thanks a lot.

Yes, acpi=off is mandatory. Unfortunately, thinkpad x60 does not boot
with acpi=off (should we add another test to linux firmware kit?
Machines should still boot in acpi=off mode...). acpi=off noapic
nolapic nosmp makes it boot, and that in turn makes kjump work.

Screen is not refreshed on kjump back to original kernel, but I guess
that's to be expected. I did not play with framebuffer, yet.

Maybe it is time to move kjump functionality into -mm and
kexec-testing?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
