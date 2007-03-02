Return-Path: <linux-kernel-owner+w=401wt.eu-S2992473AbXCBOXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992473AbXCBOXL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 09:23:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992474AbXCBOXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 09:23:11 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38964 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992473AbXCBOXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 09:23:10 -0500
Date: Fri, 2 Mar 2007 15:22:56 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jean Delvare <khali@linux-fr.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Chuck Ebbert <cebbert@redhat.com>,
       Rudolf Marek <r.marek@assembler.cz>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-ID: <20070302142256.GK2156@elf.ucw.cz>
References: <45D5EA88.7090300@redhat.com> <45D6DDCE.5050803@assembler.cz> <45D7461A.2040808@redhat.com> <20070218183805.5a4fd813.khali@linux-fr.org> <20070228213803.GA4877@ucw.cz> <20070301152655.f232db64.khali@linux-fr.org> <20070302114023.GD2163@elf.ucw.cz> <20070302114747.GB1212@srcf.ucam.org> <20070302151055.d2665d66.khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302151055.d2665d66.khali@linux-fr.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > The DSDT code clearly can't touch the hardware itself - hardware access 
> > is carried out by the kernel. If we can identify cases where ACPI reads 
> > and writes would touch resources claimed by other drivers, that would be 
> > a good starting point for working out what's going on.
> 
> I'm not familiar with APCI at all so I didn't know, but what you write
> here brings some hope. Would it be possible to parse all the DSDT code
> at boot time and deduce all the ports which ACPI would need to request
> to be safe?

I'm afraid it is about as hard as disassembling SMM BIOS to figure out
what it accesses.

> > Of course, this ignores the case where the DSDT just traps into SMM 
> > code. That one is clearly unsolvable.
> 
> Yeah, SMM is an even more complex problem :(
> 
> Do we know in advance when we are going to SMM mode and back? If we

SMM is often invoked by timer, AC unplug, etc.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
