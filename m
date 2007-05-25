Return-Path: <linux-kernel-owner+w=401wt.eu-S1758834AbXE0VAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834AbXE0VAd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 17:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbXE0VAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 17:00:23 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2049 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751316AbXE0VAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 17:00:22 -0400
Date: Fri, 25 May 2007 06:38:15 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.22-rc1-mm1 Implementing fan/thermal control in userspace - Was: [cannot change thermal trip points]
Message-ID: <20070525063815.GA3989@ucw.cz>
References: <20070521121048.GA8332@elf.ucw.cz> <20070521132711.GA7540@srcf.ucam.org> <20070521132948.GD8332@elf.ucw.cz> <20070521133608.GB7540@srcf.ucam.org> <20070521134046.GE8332@elf.ucw.cz> <20070521134553.GA7911@srcf.ucam.org> <20070521224200.GF10714@elf.ucw.cz> <20070522003153.GA18162@srcf.ucam.org> <1180016213.16396.74.camel@queen.suse.de> <20070524143644.GA27364@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070524143644.GA27364@srcf.ucam.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> 
> > I doubt it is impossible, would you mind sharing your knowledge why you
> > think it is impossible or point to some related discussion, pls.
> 
> Because, as Len has pointed out, you end up with two different ideas 
> about what the trip points are - the kernel's and the hardware's. That 
> works fine until some event in the firmware either forcibly 
> resynchronises the two or makes assumptions about the spec-compliance of 
> the interpreter.

...and suggested workaround is to drive fans directly from userspace,
which not only violates the specs and has all the problems with
desynchronized state, but ALSO FAILS TO WORK IN PRACTICE.

> > I could imagine an implementation for this, that e.g. critical...active9
> > get module parameters. BIOS updates for trip points get ignored as soon
> > as one is set and you can only decrease a value. Nothing bad can happen
> > and it will make some people happy (yes it's hacky, violates the specs
> > and so on..., but some more people have a working machine). Will this
> > (or similar) get accepted?
> 
> The interface would need to be more complicated than that if you wanted 
> to be able to implement hysteresis, and there's the potential for 
> hardware damage if paramaters are set inappropriately. Even then, 
> there's no easy way of programatically determining whether it would work 
> on any given hardware.

Not sure why you try to scare people with 'hardware damage'. HP XE3
bios already _was_ damaging hardware (it cooked the hard drive using
cpu as a heater), and no acpi magic can damage correctly working
machine.
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
