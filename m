Return-Path: <linux-kernel-owner+w=401wt.eu-S932334AbXCFVVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334AbXCFVVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 16:21:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964832AbXCFVVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 16:21:10 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44543 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932334AbXCFVVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 16:21:08 -0500
Date: Tue, 6 Mar 2007 22:20:56 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jean Delvare <khali@linux-fr.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Chuck Ebbert <cebbert@redhat.com>,
       Rudolf Marek <r.marek@assembler.cz>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-ID: <20070306212056.GC3843@elf.ucw.cz>
References: <20070301152655.f232db64.khali@linux-fr.org> <20070302114023.GD2163@elf.ucw.cz> <20070302114747.GB1212@srcf.ucam.org> <20070302151055.d2665d66.khali@linux-fr.org> <20070302141840.GA3441@srcf.ucam.org> <20070302220454.a0c66d04.khali@linux-fr.org> <20070302211251.GA10035@srcf.ucam.org> <20070303105316.d51e032d.khali@linux-fr.org> <20070305222548.GA4946@ucw.cz> <20070306162634.bcaaf0c7.khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306162634.bcaaf0c7.khali@linux-fr.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Is there anything preventing us from doing such a walk and pre-allocate
> > > all the I/O ranges? I am not familiar with the ACPI code at all, would
> > > you possibly propose a patch doing that?
> > 
> > ACPI AML is probably turing-complete: I'm afraid you are trying to
> > solve the halting problem (-> impossible).
> 
> Can you please translate this into something mere humans like myself
> have a chance to understand?

ACPI AML is turing-complete -- that means it is as powerful any
programming language. It can do arbitrary computation. That means it
is theoretically impossible to analyze its accesses using any program.

Now... may be possible to introduce _some_ ACPI BIOSes, but doing it
would certainly be very complex -- we are talking "put gcc into
kernel" here.

So no, it is not possible to preallocate the ranges.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
