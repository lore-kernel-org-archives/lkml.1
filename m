Return-Path: <linux-kernel-owner+w=401wt.eu-S1759060AbXJOOW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759060AbXJOOW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 10:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754360AbXJOOWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 10:22:21 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:47060 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348AbXJOOWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 10:22:20 -0400
Date: Mon, 15 Oct 2007 16:23:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: WANTED: kernel projects for CS students
Message-ID: <20071015142352.GA21259@uranus.ravnborg.org>
References: <20071014190128.6e3cdb44@bree.surriel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071014190128.6e3cdb44@bree.surriel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik.

On Sun, Oct 14, 2007 at 07:01:28PM -0400, Rik van Riel wrote:
> The kernel newbies community often gets inquiries from CS students who
> need a project for their studies and would like to do something with
> the Linux kernel, but would also like their code to be useful to the
> community afterwards.
> 
> In order to make it easier for them, I am trying to put together a
> page with projects that:
> - Are self contained enough that the students can implement the
>   project by themselves, since that is often a university requirement.
> - Are self contained enough that Linux could merge the code (maybe
>   with additional changes) after the student has been working on it
>   for a few months.
> - Are large enough to qualify as a student project, luckily there is
>   flexibility here since we get inquiries for anything from 6 week
>   projects to 6 month projects.
> 
> If you have ideas on what projects would be useful, please add them
> to this page (or email me):
> 
> http://kernelnewbies.org/KernelProjects

In the kernel build area a few possible projects exists.

Increase speed for a build with no updates
==========================================
On a resonably fast machine with a decent config it takes
roughly 10 seconds to do a make where nothing is updated.
Generating one single Makefile is assumed to speed up things
and will in addition allow a simpler syntax as what is used today
for some of the uglier constructs.

Contact: Sam Ravnborg <sam@ravnborg.org>
Difficulty: 5
Language: Perl or C


Increase speed for a build wich updates a single file
=====================================================
We often edit a single file and then do a build.
And the result is that we spend 80% of the time linking
the kernel.
So an obvious improvement for the kernel community would
be to improve the speed of the linker (and decrease memory footprint).

Contact: ?
Difficulty: ?
Language: C

Update menuconfig to a modern ncurses look&feel
===============================================
htop, aptitude, tig and other ncurses based programs has
a more modern and effective look&feel than current menuconfig.
Rip out all the lxdialog stuff and replace it with a ncurses
based frontend that looks better and has more functionality.

Contact: Sam Ravnborg <sam@ravnborg.org>
Difficulty: 5
Language: C


They are independent but challenging and would be very much appreciated
by the kernel community.

I could come up with more projects but these are the ones that are most
straightforward to start with.

	Sam
