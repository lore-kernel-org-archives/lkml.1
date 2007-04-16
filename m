Return-Path: <linux-kernel-owner+w=401wt.eu-S1751951AbXDPKDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbXDPKDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 06:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbXDPKDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 06:03:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56493 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbXDPKDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 06:03:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [2/2] 2.6.21-rc7: known regressions
Date: Mon, 16 Apr 2007 12:06:22 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Chua <jeff.chua.linux@gmail.com>, pavel@suse.cz,
       linux-pm@lists.osdl.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Dave Jones <davej@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Dmitry Torokhov <dtor@insightbb.com>,
       David Brownell <david-b@pacbell.net>, Marcus Better <marcus@better.se>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       James Simmons <jsimmons@infradead.org>
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org> <20070416003723.GM3691@stusta.de>
In-Reply-To: <20070416003723.GM3691@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704161206.31145.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 16 April 2007 02:37, Adrian Bunk wrote:
> This email lists some known regressions in Linus' tree compared to 2.6.20.
> 
> If you find your name in the Cc header, you are either submitter of one
> of the bugs, maintainer of an affectected subsystem or driver, a patch
> of you caused a breakage or I'm considering you in any other way
> possibly involved with one or more of these issues.
> 
> Due to the huge amount of recipients, please trim the Cc when answering.
> 
[--snip--]
> 
> 
> Subject    : suspend to disk works only once
> References : http://lkml.org/lkml/2007/4/13/240
> Submitter  : Tobias Diedrich <ranma+kernel@tdiedrich.de>
> Caused-By  : Rafael J. Wysocki <rjw@sisk.pl>
>              commit ed746e3b18f4df18afa3763155972c5835f284c5
> Handled-By : Rafael J. Wysocki <rjw@sisk.pl>
>              Dmitry Torokhov <dtor@insightbb.com>
>              David Brownell <david-b@pacbell.net>
> Status     : problem is being debugged

Workaround is possible: do "echo shutdown > /sys/power/disk" before the
suspend or, for s2disk, add "shutdown method = shutdown" to the configuration
file.

Greetings,
Rafael
