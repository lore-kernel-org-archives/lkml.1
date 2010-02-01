Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab0BAJVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 04:21:37 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57407 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab0BAJVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 04:21:36 -0500
Subject: Re: Lock dependency based tree report in perf lock
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100201012331.GH5224@nowhere>
References: <20100129231723.GB5052@nowhere>
	 <1264841188.24455.54.camel@laptop>  <20100201012331.GH5224@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 10:21:09 +0100
Message-ID: <1265016069.24455.107.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 02:23 +0100, Frederic Weisbecker wrote:
> On Sat, Jan 30, 2010 at 09:46:28AM +0100, Peter Zijlstra wrote:
> > On Sat, 2010-01-30 at 00:17 +0100, Frederic Weisbecker wrote:
> > > 
> > > 
> > > Anyway, that's just an idea, not trivial I must admit.
> > 
> > lockdep actually collects all this information, so writing it out isn't
> > too hard.
> 
> 
> Hmm, I'm discovering the /proc/lock_stat file this evening, did not
> know it exist :)
> 
> Still, a tree representation can bring another dimension.

current->held_locks[i]->instance, i < current->lock_depth

