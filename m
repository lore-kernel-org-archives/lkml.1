Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbZBCPYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbZBCPYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 10:24:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbZBCPYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 10:24:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37192 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbZBCPYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 10:24:35 -0500
Date: Tue, 3 Feb 2009 16:24:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 1/1] blktrace: fix coding style in recent patches
Message-ID: <20090203152416.GH29046@elte.hu>
References: <20090203135829.GH17781@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203135829.GH17781@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Impact: cleanup
>     
> I introduced some, then, while testing with checkpatch --file
> block/blktrace.c I saw some long lines and fixed those too, some were
> even from older patches I sent, shame on me ;-\
>     
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

applied to tip:tracing/blktrace, thanks Arnaldo!

btw., there's only one warning remaining in all of blktrace.c:

| CHECK: memory barrier without comment
| #555: FILE: blktrace.c:555:
| +			smp_mb();
|
| total: 0 errors, 1 warnings, 1 checks, 1549 lines checked

and here checkpatch is kind of right that we should document this particular 
smp_mb(). If you stick a comment in front of that statement, explaining that 
barrier, then checkpatch will stop complaining.

	Ingo
