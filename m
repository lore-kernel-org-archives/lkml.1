Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbYDYLEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbYDYLEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 07:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750901AbYDYLEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 07:04:13 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:59210 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbYDYLEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 07:04:12 -0400
Date: Fri, 25 Apr 2008 13:04:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Matt Helsley <matthltc@us.ibm.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Cedric Le Goater <clg@fr.ibm.com>, Paul Menage <menage@google.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [RFC][PATCH 2/5] Container Freezer: Make refrigerator always
	available
Message-ID: <20080425110456.GF14903@elf.ucw.cz>
References: <20080424064756.643890130@us.ibm.com> <20080424064757.227289200@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080424064757.227289200@us.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Now that the TIF_FREEZE flag is available in all architectures,
> extract the refrigerator() and freeze_task() from kernel/power/process.c
> and make it available to all.
> 
> The refrigerator() can now be used in a control group subsystem 
> implementing a control group freezer.
> 
> Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
> Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
> Tested-by: Matt Helsley <matthltc@us.ibm.com>

There's no problem with doing this... but you should get some debate
(with Linus?) whether using freezer for cgroups is sane. When that is
done, there's no problem with this going in, probably through rafael's
patch queue.

(The first patch -- add freezer for all archs -- is probably
reasonably to go in ASAP, through akpm or something...)
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
