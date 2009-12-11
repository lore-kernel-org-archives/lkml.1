Return-Path: <linux-kernel-owner+w=401wt.eu-S1758830AbZLKSJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830AbZLKSJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 13:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758672AbZLKSJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 13:09:36 -0500
Received: from www.tglx.de ([62.245.132.106]:53104 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758669AbZLKSJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 13:09:36 -0500
Date: Fri, 11 Dec 2009 19:08:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Vegard Nossum <vegardno@ifi.uio.no>
Subject: Re: [patch 8/9] Documentation: Fix invalid rcu assumptions
In-Reply-To: <20091211163729.GD6803@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.00.0912111902350.3089@localhost.localdomain>
References: <20091210004703.308396881@linutronix.de> <20091210001308.247025548@linutronix.de> <13688.1260540024@redhat.com> <alpine.LFD.2.00.0912110804430.3560@localhost.localdomain> <20091211163729.GD6803@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Dec 2009, Paul E. McKenney wrote:
> On Fri, Dec 11, 2009 at 08:07:45AM -0800, Linus Torvalds wrote:
> > 
> > 
> > On Fri, 11 Dec 2009, David Howells wrote:
> > 
> > > Thomas Gleixner <tglx@linutronix.de> wrote:
> > > 
> > > > -197          * we use RCU protection here
> > > > +196          * caller must be holding the RCU readlocke
> > > 
> > > You mean "readlock" I suspect.
> > 
> > Or maybe he's talking about ye olde readlocke, used widely for OS research 
> > throughout the middle ages. You still find that spelling in some really 
> > old CS literature.
> 
> Interestingly enough, they also tended to split it into two words and
> capitalize it, as can be seen by searching for "Read Locke" at
> 
> 	http://faculty.uml.edu/enelson/modern07.htm

The good thing about "Read Locke" is: there is no "Write Locke".

Thanks,
    	 tglx
