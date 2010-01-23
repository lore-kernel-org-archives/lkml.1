Return-Path: <linux-kernel-owner+w=401wt.eu-S1751836Ab0AWG5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab0AWG5z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 01:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431Ab0AWG5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 01:57:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54795 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab0AWG5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 01:57:54 -0500
Date: Sat, 23 Jan 2010 07:57:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jason Baron <jbaron@redhat.com>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <srostedt@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 00/12] perf lock: New subcommand "perf lock", for
 analyzing lock statistics
Message-ID: <20100123065726.GA15774@elte.hu>
References: <1264167553-6510-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <20100122164248.GA2651@redhat.com>
 <1264178909.4283.1543.camel@laptop>
 <1264179169.4283.1545.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264179169.4283.1545.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2010-01-22 at 17:48 +0100, Peter Zijlstra wrote:
> > On Fri, 2010-01-22 at 11:42 -0500, Jason Baron wrote:
> > > On Fri, Jan 22, 2010 at 10:39:01PM +0900, Hitoshi Mitake wrote:
> > > > Adding new subcommand "perf lock" to perf.
> > > > 
> > > 
> > > looks like a really intresting patch! Does this patch mean that we can
> > > potentially remove CONFIG_LOCK_STAT, now that the functionality is
> > > available via 'perf'? Another desire for me has been to able to run
> > > lockstat on production box. This has not been possible before without
> > > incurring the performance penalty of lockdep. however, with 'perf' tools
> > > ability to be turned on an off, perhaps there is (or we can build) a
> > > mode for lockdep that is lower overhead for this usecase?
> > 
> > boot with: prove_locking=0
> > 
> > This patch still needs all the hooks and bits from lockdep, no way you 
> > want all that in a prodction kernel.
> 
> Also, I suspect lockstat to still be lots faster, since it doesn't need to 
> transfer gobs of data but builds the histogram in-kernel.
> 
> Having the ability to do in-kernel histrograms with perf is something I've 
> thought about but not yet managed to think of a nice way of doing it.

Yeah, that has come up in the past and it would be excellent to have. That 
would allow the removal of the special-purpose lockstat /proc output.

	Ingo
