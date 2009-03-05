Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbZCEIQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbZCEIQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 03:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbZCEIQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 03:16:36 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35647 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbZCEIQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 03:16:36 -0500
Date: Thu, 5 Mar 2009 09:19:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Schwab <schwab@suse.de>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Reworking suspend-resume sequence (was: Re: PCI PM: Restore
	standard config registers of all devices early)
Message-ID: <20090305081908.GA30418@elf.ucw.cz>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <200902032253.42709.rjw@sisk.pl> <1233700390.16867.97.camel@pasglop> <200902032344.22348.rjw@sisk.pl> <1233702327.16867.109.camel@pasglop> <alpine.LFD.2.00.0902031514510.3247@localhost.localdomain> <20090304080212.GA1489@ucw.cz> <1236209104.6696.73.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236209104.6696.73.camel@pasglop>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-03-05 10:25:04, Benjamin Herrenschmidt wrote:
> 
> > As long as we claim to support cpu hotplug, suspending the cpus early
> > should work. User might have unplugged the cpu manually...
> > 
> > If something is broken in acpi, we may need to disable  cpu*/onlone on
> >  affected systems.
> 
> You seem to miss some context here... it seems that ACPI mandates that
> CPUs are suspended after devices and you know that we can't just start
> blacklisting half of the machines out there just because we happen not
> to do the same as what Windows does...

I did not see that ACPI mandate... where is it?

 That would interfere with user's ability to online/offline cpus,
badly.

Are you saying that we should online all the CPUs before starting
suspend to stay on the "safe side"?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
