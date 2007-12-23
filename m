Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbXLWOOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbXLWOOO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 09:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbXLWON7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:13:59 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42744 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbXLWON6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:13:58 -0500
Date: Sun, 23 Dec 2007 15:15:00 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
Message-ID: <20071223141500.GB6430@one.firstfloor.org>
References: <Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com> <20071221225413.GA26189@elte.hu> <p731w9ffu8c.fsf@bingen.suse.de> <20071222100326.GF26157@elte.hu> <alpine.LFD.0.9999.0712220937560.21557@woody.linux-foundation.org> <20071222192550.GD28891@thunk.org> <alpine.LFD.0.9999.0712221251110.21557@woody.linux-foundation.org> <20071222221050.GA20753@1wt.eu> <Pine.LNX.4.58.0712221954530.19187@gandalf.stny.rr.com> <20071223051241.GA4449@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071223051241.GA4449@1wt.eu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Same here. In fact, I've always considered that procfs was for
> humans while sysfs was for tools. sysfs reminds me too much the
> unexploitable /devices in Solaris. With the proper tools, I think
> we can do a lot with it, but it's not as intuitive to find the
> proper tools as it was to do "ls" followed by "cat" in /proc.

find /sys/... -type f | while read i ; do echo "$i: $(<$i)" ; done

tends to work reasonably well for a quick overview, but yes
cat was nicer for humans.

-Andi
