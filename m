Return-Path: <linux-kernel-owner+w=401wt.eu-S1760487AbYD2Tbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760487AbYD2Tbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYD2Tbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 15:31:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36712 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755096AbYD2Tbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 15:31:37 -0400
Date: Tue, 29 Apr 2008 21:29:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: Arjan van de Ven <arjan@infradead.org>, akpm@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [2/2] vmallocinfo: Add caller information
Message-ID: <20080429192913.GA18279@elte.hu>
References: <20080318222701.788442216@sgi.com> <20080318222827.519656153@sgi.com> <20080429084854.GA14913@elte.hu> <Pine.LNX.4.64.0804291001420.10847@schroedinger.engr.sgi.com> <20080428124849.4959c419@infradead.org> <Pine.LNX.4.64.0804291143080.12128@schroedinger.engr.sgi.com> <20080428140026.32aaf3bf@infradead.org> <Pine.LNX.4.64.0804291204450.12689@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804291204450.12689@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <clameter@sgi.com> wrote:

> On Mon, 28 Apr 2008, Arjan van de Ven wrote:
> 
> > > Hmmm... Why do we have CONFIG_FRAMEPOINTER then?
> > 
> > to make the backtraces more accurate.
> 
> Well so we display out of whack backtraces? There are also issues on 
> platforms that do not have a stack in the classic sense (rotating 
> register file on IA64 and Sparc64 f.e.). Determining a backtrace can 
> be very expensive.

they have to solve that for kernel oopses and for lockdep somehow 
anyway. Other users of stacktrace are: fault injection, kmemcheck, 
latencytop, ftrace. All new debugging and instrumentation code uses it, 
and for a good reason.

	Ingo
