Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbXDPA5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbXDPA5z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 20:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbXDPA5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 20:57:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139AbXDPA5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 20:57:53 -0400
Date: Sun, 15 Apr 2007 20:54:46 -0400
From: Dave Jones <davej@redhat.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Chua <jeff.chua.linux@gmail.com>, pavel@suse.cz,
       linux-pm@lists.osdl.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Dmitry Torokhov <dtor@insightbb.com>,
       David Brownell <david-b@pacbell.net>, Marcus Better <marcus@better.se>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       James Simmons <jsimmons@infradead.org>
Subject: Re: [2/2] 2.6.21-rc7: known regressions
Message-ID: <20070416005446.GB21217@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Adrian Bunk <bunk@stusta.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Jeff Chua <jeff.chua.linux@gmail.com>, pavel@suse.cz,
	linux-pm@lists.osdl.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, gregkh@suse.de,
	linux-pci@atrey.karlin.mff.cuni.cz,
	Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Dmitry Torokhov <dtor@insightbb.com>,
	David Brownell <david-b@pacbell.net>,
	Marcus Better <marcus@better.se>,
	"Antonino A. Daplas" <adaplas@gmail.com>,
	James Simmons <jsimmons@infradead.org>
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org> <20070416003723.GM3691@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070416003723.GM3691@stusta.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 02:37:23AM +0200, Adrian Bunk wrote:

 > Subject    : ThinkPad X60: resume no longer works  (PCI related?)
 >              workaround: booting with "hpet=disable"
 > References : http://lkml.org/lkml/2007/3/13/3
 > Submitter  : Dave Jones <davej@redhat.com>
 >              Jeremy Fitzhardinge <jeremy@goop.org>
 > Caused-By  : PCI merge
 >              commit 78149df6d565c36675463352d0bfe0000b02b7a7
 > Handled-By : Eric W. Biederman <ebiederm@xmission.com>
 >              Rafael J. Wysocki <rjw@sisk.pl>
 > Status     : unknown

note that this workaround doesn't seem to work in all cases.
Mine may a slightly different model (I have the tablet version)
but disabling hpet shows the same regression.
I've been fighting Eric's USB debug cable code in the hope
of getting _something_ useful out of it other than a black screen,
but I've been getting nowhere with it.

	Dave

-- 
http://www.codemonkey.org.uk
