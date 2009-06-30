Return-Path: <linux-kernel-owner+w=401wt.eu-S1759189AbZF3Hf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759189AbZF3Hf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 03:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbZF3HfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 03:35:18 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50210 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbZF3HfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 03:35:17 -0400
Date: Tue, 30 Jun 2009 09:35:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, penberg@cs.helsinki.fi,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, npiggin@suse.de
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Message-ID: <20090630073513.GB22878@elf.ucw.cz>
References: <20090624105517.904f93da.akpm@linux-foundation.org> <4A426825.80905@cs.helsinki.fi> <20090624113037.7d72ed59.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241134510.3240@localhost.localdomain> <20090624120617.1e6799b5.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain> <20090624123624.26c93459.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain> <20090628101654.GB8673@ucw.cz> <alpine.LFD.2.01.0906281101030.3605@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906281101030.3605@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-06-28 11:01:42, Linus Torvalds wrote:
> 
> On Sun, 28 Jun 2009, Pavel Machek wrote:
> > 
> > Ok, so we should re-add that 4MB buffer to suspend, so that
> > allocations work even during that, right?
> 
> Pavel, you really are a one-trick pony, aren't you?
> 
> Give it up. Return to your pet worry when there are any actual reports. As 
> you have been told several times.

How do you report something that results in black screen during
suspend in 1/100 of attempts?

> The _other_ part of memory management that you and Andrew seem to be 
> ignoring is that it's very robust, and keeps extra memory around, and just 
> generally does the right thing. We don't generally pre-allocate anything, 
> because we don't need to.
> 
> Almost the _only_ way to run out of memory is to have tons and tons of 
> dirty pages around. Yes, it can happen. But if it happens, you're almost 
> guaranteed to be screwed anyway. The whole VM is designed around the 
> notion that most of memory is just clean caches, and it's designed around 
> that simply because if it's not true, the VM freedom is so small that 
> there's not a lot a VM can reasonably do.

Well, or you can have machine with not nearly enough memory (like 16MB
system), or huge 32-bit highmem system (32GB).

But it is true that I did not see OOM for quite long time.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
