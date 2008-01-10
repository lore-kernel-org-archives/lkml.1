Return-Path: <linux-kernel-owner+w=401wt.eu-S1756821AbYAJJE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbYAJJE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 04:04:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbYAJJEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 04:04:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45983 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbYAJJEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 04:04:39 -0500
Date: Thu, 10 Jan 2008 10:04:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch]  Add a simple backtrace test module
Message-ID: <20080110090429.GA23878@elte.hu>
References: <20080109224208.541a659f@laptopd505.fenrus.org> <20080110083934.GC10745@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110083934.GC10745@infradead.org>
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


* Christoph Hellwig <hch@infradead.org> wrote:

> On Wed, Jan 09, 2008 at 10:42:08PM -0800, Arjan van de Ven wrote:
> > 
> > Subject: Add a simple backtrace test module
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > 
> > During the work on the x86 32 and 64 bit backtrace code I found it 
> > useful to have a simple test module to test a process and irq 
> > context backtrace. Since the existing backtrace code was buggy, I 
> > figure it might be useful to have such a test module in the kernel 
> > so that maybe we can even detect such bugs earlier..
> 
> Care to add new testcases to a new tests/ subdirectory so we can have 
> them in one place?

yeah, agreed, we'll clean this all up, and move the other testcode there 
too, ok? There's rcutorture, lock-selftests, rt-tester, 
kprobes-smoke-test and now backtracetest.

Arjan might as well want to use the opportunity and break new kernel 
namespace ground by creating the tests/ directory for the first time in 
Linux history and introduce tests/backtracetest.c :-)

	Ingo
