Return-Path: <linux-kernel-owner+w=401wt.eu-S1757718AbZLKQhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718AbZLKQhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 11:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbZLKQh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 11:37:27 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:48173 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbZLKQh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 11:37:26 -0500
Date: Fri, 11 Dec 2009 08:37:30 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Vegard Nossum <vegardno@ifi.uio.no>
Subject: Re: [patch 8/9] Documentation: Fix invalid rcu assumptions
Message-ID: <20091211163729.GD6803@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091210004703.308396881@linutronix.de> <20091210001308.247025548@linutronix.de> <13688.1260540024@redhat.com> <alpine.LFD.2.00.0912110804430.3560@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912110804430.3560@localhost.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 08:07:45AM -0800, Linus Torvalds wrote:
> 
> 
> On Fri, 11 Dec 2009, David Howells wrote:
> 
> > Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > -197          * we use RCU protection here
> > > +196          * caller must be holding the RCU readlocke
> > 
> > You mean "readlock" I suspect.
> 
> Or maybe he's talking about ye olde readlocke, used widely for OS research 
> throughout the middle ages. You still find that spelling in some really 
> old CS literature.

Interestingly enough, they also tended to split it into two words and
capitalize it, as can be seen by searching for "Read Locke" at

	http://faculty.uml.edu/enelson/modern07.htm

							Thanx, Paul
