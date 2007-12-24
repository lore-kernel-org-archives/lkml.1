Return-Path: <linux-kernel-owner+w=401wt.eu-S1754274AbXLXD52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbXLXD52 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 22:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbXLXD5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 22:57:19 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60818 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349AbXLXD5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 22:57:18 -0500
X-Greylist: delayed 545 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Dec 2007 22:57:17 EST
Date: Sun, 23 Dec 2007 22:45:30 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Andi Kleen <andi@firstfloor.org>
Cc: Willy Tarreau <w@1wt.eu>, Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
Message-ID: <20071224034530.GB16658@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andi Kleen <andi@firstfloor.org>, Willy Tarreau <w@1wt.eu>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
References: <20071221225413.GA26189@elte.hu> <p731w9ffu8c.fsf@bingen.suse.de> <20071222100326.GF26157@elte.hu> <alpine.LFD.0.9999.0712220937560.21557@woody.linux-foundation.org> <20071222192550.GD28891@thunk.org> <alpine.LFD.0.9999.0712221251110.21557@woody.linux-foundation.org> <20071222221050.GA20753@1wt.eu> <Pine.LNX.4.58.0712221954530.19187@gandalf.stny.rr.com> <20071223051241.GA4449@1wt.eu> <20071223141500.GB6430@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071223141500.GB6430@one.firstfloor.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2007 at 03:15:00PM +0100, Andi Kleen wrote:
> > Same here. In fact, I've always considered that procfs was for
> > humans while sysfs was for tools. sysfs reminds me too much the
> > unexploitable /devices in Solaris. With the proper tools, I think
> > we can do a lot with it, but it's not as intuitive to find the
> > proper tools as it was to do "ls" followed by "cat" in /proc.
> 
> find /sys/... -type f | while read i ; do echo "$i: $(<$i)" ; done
> 
> tends to work reasonably well for a quick overview, but yes
> cat was nicer for humans.

Until you start to wonder what the heck :a-0000136 is:

/sys/slab/:a-0000136/objs_per_slab: 30

Sigh...

					- Ted

