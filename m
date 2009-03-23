Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbZCWKfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbZCWKfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 06:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755316AbZCWKf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 06:35:29 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44695 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197AbZCWKf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 06:35:28 -0400
Date: Mon, 23 Mar 2009 11:38:21 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Li Yang <leoli@freescale.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: nonboot cpu on SMP suspend
Message-ID: <20090323103821.GC17681@elf.ucw.cz>
References: <2a27d3730903172325w16ec329cp872ec35d100f6506@mail.gmail.com> <20090320185851.GB1418@ucw.cz> <2a27d3730903230015h6cc320bek423764eb496d6b30@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2a27d3730903230015h6cc320bek423764eb496d6b30@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-03-23 15:15:57, Li Yang wrote:
> On Sat, Mar 21, 2009 at 2:58 AM, Pavel Machek <pavel@ucw.cz> wrote:
> > On Wed 2009-03-18 14:25:32, Li Yang wrote:
> >> Hi all,
> >>
> >> I'm curious why we need to un-plug all the nonboot cpus before suspend
> >> and start them all over again after the suspend(ACPI sleep)?  I mean
> >> if we can bring the booting cpu back to the exact state as before
> >> suspend, why can't we just do the same for non-booting cpus?  And that
> >> will be much faster.  Any thought?  Thanks.
> >
> > Why do you think it will be faster?
> 
> _cpu_down() and _cpu_up() are surely complex functions, involving
> work_queues and synchronization between boot cpu and non-boot cpu.  On
> the contrary, to bring the cpu back to previous state is much simpler.
>  For standby state, you barely need to do anything.  For mem state,
> you only need to restore the registers and states of the CPU.

Feel free to cook up a patch.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
