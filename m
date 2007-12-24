Return-Path: <linux-kernel-owner+w=401wt.eu-S1753130AbXLXTVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbXLXTVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 14:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbXLXTVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 14:21:18 -0500
Received: from relay1.sgi.com ([192.48.171.29]:36894 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751262AbXLXTVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 14:21:17 -0500
Date: Mon, 24 Dec 2007 11:21:14 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Theodore Tso <tytso@MIT.EDU>
cc: Andi Kleen <andi@firstfloor.org>, Willy Tarreau <w@1wt.eu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
In-Reply-To: <20071224034530.GB16658@thunk.org>
Message-ID: <Pine.LNX.4.64.0712241120230.8849@schroedinger.engr.sgi.com>
References: <20071221225413.GA26189@elte.hu> <p731w9ffu8c.fsf@bingen.suse.de>
 <20071222100326.GF26157@elte.hu> <alpine.LFD.0.9999.0712220937560.21557@woody.linux-foundation.org>
 <20071222192550.GD28891@thunk.org> <alpine.LFD.0.9999.0712221251110.21557@woody.linux-foundation.org>
 <20071222221050.GA20753@1wt.eu> <Pine.LNX.4.58.0712221954530.19187@gandalf.stny.rr.com>
 <20071223051241.GA4449@1wt.eu> <20071223141500.GB6430@one.firstfloor.org>
 <20071224034530.GB16658@thunk.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Dec 2007, Theodore Tso wrote:

> > tends to work reasonably well for a quick overview, but yes
> > cat was nicer for humans.
> 
> Until you start to wonder what the heck :a-0000136 is:
> 
> /sys/slab/:a-0000136/objs_per_slab: 30
> 
> Sigh...

That is why there is a slabinfo tool that does all the nice formatting.

Do a

gcc -o slabinfo Documentation/vm/slabinfo.c 

Then run slabinfo instead of doing cat /proc/slabinfo


