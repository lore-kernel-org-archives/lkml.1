Return-Path: <linux-kernel-owner+w=401wt.eu-S1758476AbXIIPH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758476AbXIIPH3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 11:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757862AbXIIPG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 11:06:57 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1887 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757442AbXIIPG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 11:06:56 -0400
Date: Sun, 9 Sep 2007 14:48:33 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       colin.michael@o2online.de, linux-kernel@vger.kernel.org
Subject: Re: [patch] enable userspace cpu core voltage control with acpi-cpufreq
Message-ID: <20070909144833.GC4777@ucw.cz>
References: <200709021441.l82EfWCe022642@mail.mc.o2online.de> <p738x7oaugi.fsf@bingen.suse.de> <20070903152457.GC21586@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070903152457.GC21586@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-09-03 11:24:57, Dave Jones wrote:
> On Mon, Sep 03, 2007 at 12:56:13PM +0200, Andi Kleen wrote:
>  > <colin.michael@o2online.de> writes:
>  > 
>  > > i want to make a patch known that provides a userspace interface to control the core voltage of a computer processor(s).
>  > 
>  > That would be essentially linux supported undervolting which 
>  > for stability is as bad as overclocking. The problem is that 
>  > such games tend to generate weird kernel crashes and then
>  > chew up development issues when kernel hackers have to chase
>  > ghost bugs. I don't think we should support it. Developer 
>  > time is too precious.
>  
> Seconded.  Exactly the same reasons I've refused to merge patches
> into cpufreq to allow arbitrary tables to override BIOS tables.
> Or patches to remove boundary checks.   Even when correctly
> implemented, this stuff can be fragile as hell, so introducing
> more things that cast doubt over its stability isn't something
> I'm keen on at all.

If it saves 15W out of 55W... I'd say we want that. It should taint
the kernel, but it should be possible.

Heck, people have BIOSen that allow overclocking, and there are
bin-only modules out there. This is not worse than either of those.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
