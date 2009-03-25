Return-Path: <linux-kernel-owner+w=401wt.eu-S1756476AbZCYRBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476AbZCYRBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbZCYRBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:01:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45066 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbZCYRBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:01:31 -0400
Date: Wed, 25 Mar 2009 18:01:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org, Alexander Viro <viro@ftp.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro,
       viro@zeniv.linux.org.uk, tglx@linutronix.de, adobriyan@gmail.com
Subject: Re: [tip:tracing/kmemtrace] fs.h: uninline simple_transaction_set()
Message-ID: <20090325170111.GB14250@elte.hu>
References: <1237898630.25315.83.camel@penberg-laptop> <tip-44eea45ca9e25d6dd660d4806ef4c11209609e03@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-44eea45ca9e25d6dd660d4806ef4c11209609e03@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Commit-ID:  44eea45ca9e25d6dd660d4806ef4c11209609e03
> Gitweb:     http://git.kernel.org/tip/44eea45ca9e25d6dd660d4806ef4c11209609e03
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Wed, 25 Mar 2009 16:48:35 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 25 Mar 2009 17:48:14 +0100
> 
> fs.h: uninline simple_transaction_set()

> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> Cc: paulmck@linux.vnet.ibm.com
> LKML-Reference: <1237898630.25315.83.camel@penberg-laptop>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Pekka, Eduard - this commit is needed for the kmemtrace branch 
(otherwise headers_check fails) - but it needs the ack of Al Viro - 
so i've ordered the branch accordingly.

The fs.h changes look trivial and a step forward to me in untangling 
the data type dependency spaghetti (a tiny bit):

 44eea45: fs.h: uninline simple_transaction_set()
 55553d2: fs, kmemtrace: fix fs.h's PAGE_SIZE dependency
 f3edf88: kmemtrace, fs, security: move alloc_secdata() and free_secdata() linux/security
 f9ebc8b: fs: don't include <linux/gfp.h> to fix headers-export-check
 c60d3ef: kmemtrace: fix build brekage in linux/fs.h

but it needs Acks.

Thanks,

	Ingo
