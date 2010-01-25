Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653Ab0AYHvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab0AYHvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 02:51:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772Ab0AYHu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 02:50:59 -0500
Received: from thunk.org ([69.25.196.29]:48797 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960Ab0AYHu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 02:50:58 -0500
Date: Sun, 24 Jan 2010 23:55:01 -0500
From: tytso@mit.edu
To: Kyle Moffett <kyle@moffetthome.net>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100125045501.GC4372@thunk.org>
Mail-Followup-To: tytso@mit.edu, Kyle Moffett <kyle@moffetthome.net>,
	"Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Peter Zijlstra <peterz@infradead.org>,
	Fr??d??ric Weisbecker <fweisbec@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	linux-next@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	utrace-devel@redhat.com, Thomas Gleixner <tglx@linutronix.de>
References: <20100122200129.GG22003@redhat.com>
 <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain>
 <20100122221348.GA4263@redhat.com>
 <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain>
 <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>
 <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com>
 <20100123112333.GA15455@elte.hu>
 <20100123114729.GA7828@redhat.com>
 <20100123194820.GM21263@thunk.org>
 <f73f7ab81001241742t1f827ddetd958e1949787020f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f73f7ab81001241742t1f827ddetd958e1949787020f@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 24, 2010 at 08:42:13PM -0500, Kyle Moffett wrote:
> 
> Personally I don't give a flying **** about SystemTap; I'm interested
> in things like the ability to stack gdb with strace, the RFC gdb-stub
> posted a week ago, etc.  None of those abilities would be out-of-tree
> modules at all, and therefore the "quicksand" analogy is specious.

Great.  So what should be reviewed is utrace *plus* these other
userland interfaces, which may get critiqued and improved, and utrace
patches can be reviewed in light of these new features.  But be
warned.... if it turns out that only 30% of utrace is only needed to
support gdb stacking with strace, etc., the other 70% will likely get
ejected and the utrace patches streamlined to support these in-tree
users.  But since you don't give a flying **** about SystemTap,
presumably you won't mind, right?


> I would be willing to guess that something like 95% of the people
> using SystemTap or other tools are doing so on Red Hat Enterprise
> Linux or other enterprise supported platforms, and so when something
> breaks they go whinge at Red Hat, etc.  If I recall correctly Red Hat
> and many of the other vendors already heavily fiddle with kernel
> patches they apply to provide some amount of binary module
> compatibility.

Sure, but as out-of-tree modules, the best they can expect is that
most kernel developers will pretend that they don't exist.  Which is
OK, when I tried using SystemTap most of the concerns which I
expressed as being critical for kernel developers were largely ignored
(as near as I could tell) because the target market was RHEL corporate
customers, and they prioritized their resourcing accordingly --- so
they shouldn't mind if kernel developers return the favor.

But that means that we should only merge those portions of utrace that
are needed for these alleged "killer new features", and only if these
new features are cool enough that they justify the new code on their
own merits.   At least, IMNSHO.

						- Ted
