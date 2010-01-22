Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261Ab0AVQtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab0AVQtA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 11:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754942Ab0AVQs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 11:48:59 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36090 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab0AVQs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 11:48:59 -0500
Subject: Re: [PATCH 00/12] perf lock: New subcommand "perf lock", for
 analyzing lock statistics
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <srostedt@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <20100122164248.GA2651@redhat.com>
References: <1264167553-6510-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <20100122164248.GA2651@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jan 2010 17:48:29 +0100
Message-ID: <1264178909.4283.1543.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-22 at 11:42 -0500, Jason Baron wrote:
> On Fri, Jan 22, 2010 at 10:39:01PM +0900, Hitoshi Mitake wrote:
> > Adding new subcommand "perf lock" to perf.
> > 
> 
> looks like a really intresting patch! Does this patch mean that we can
> potentially remove CONFIG_LOCK_STAT, now that the functionality is
> available via 'perf'? Another desire for me has been to able to run
> lockstat on production box. This has not been possible before without
> incurring the performance penalty of lockdep. however, with 'perf' tools
> ability to be turned on an off, perhaps there is (or we can build) a
> mode for lockdep that is lower overhead for this usecase?

boot with: prove_locking=0

This patch still needs all the hooks and bits from lockdep, no way you
want all that in a prodction kernel.

