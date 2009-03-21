Return-Path: <linux-kernel-owner+w=401wt.eu-S1755089AbZCUWCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbZCUWCn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 18:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbZCUWCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 18:02:35 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59947 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbZCUWCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 18:02:34 -0400
Date: Sat, 21 Mar 2009 23:05:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "J.R. Mauro" <jrm8005@gmail.com>
Cc: Christopher Brannon <cmbrannon@cox.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] /dev/time for Linux, inspired by Plan 9
Message-ID: <20090321220522.GE12291@elf.ucw.cz>
References: <20090311200411.WPUP4619.eastrmmtao102.cox.net@eastrmimpo02.cox.net> <20090314161341.GB1496@ucw.cz> <3aaafc130903170815x7704d9f0gdb6012bbf63e2a5b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3aaafc130903170815x7704d9f0gdb6012bbf63e2a5b@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-03-17 11:15:09, J.R. Mauro wrote:
> On Sat, Mar 14, 2009 at 12:13 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > On Wed 2009-03-11 10:10:23, Christopher Brannon wrote:
> >> Under Plan 9 from Bell Labs, one queries or sets the system clock by
> >> reading or writing text strings to a special file named /dev/time.
> >> I implemented such a facility for Linux.  A read of /dev/time produces
> >> four decimal numbers: epoch seconds, nanoseconds since start of epoch,
> >> nanoseconds since boot, and nanoseconds per second.  Writing a
> >> decimal number
> >
> > nanoseconds per second?! Just use 123.456 notation.
> 
> The point is to be close to Plan 9's interface, in which column 3 is
> "something since boot" and column 4 is "somethings per second" to keep
> programs portable.

I don't think compatibility with Plan9 is worthy goal... especially
when Plan9's interface is unneccessarily ugly.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
