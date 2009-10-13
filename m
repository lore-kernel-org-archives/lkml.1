Return-Path: <linux-kernel-owner+w=401wt.eu-S1756329AbZJMF6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329AbZJMF6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 01:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbZJMF6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 01:58:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47072 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754912AbZJMF6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 01:58:33 -0400
Date: Tue, 13 Oct 2009 07:57:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: mm-commits@vger.kernel.org, randy.dunlap@oracle.com, dhowells@redhat.com
Subject: Re: +
	mutex-subsystem-synchro-test-module-add-missing-header-file.patch
	added to -mm tree
Message-ID: <20091013055743.GA2594@elte.hu>
References: <200910130232.n9D2WRvr026737@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910130232.n9D2WRvr026737@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:

> Subject: synchro-test: add missing header file
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix build errors, add <sched.h> header file:
> 
> kernel/synchro-test.c: In function 'sched':
> kernel/synchro-test.c:220: error: implicit declaration of function 'schedule'
> kernel/synchro-test.c: In function 'mutexer':
> kernel/synchro-test.c:227: error: implicit declaration of function 'daemonize'
> kernel/synchro-test.c:228: error: implicit declaration of function 'set_user_nice'
> kernel/synchro-test.c:241: error: dereferencing pointer to incomplete type
> kernel/synchro-test.c: In function 'semaphorer':
> kernel/synchro-test.c:263: error: dereferencing pointer to incomplete type
> kernel/synchro-test.c: In function 'reader':
> kernel/synchro-test.c:287: error: dereferencing pointer to incomplete type
> kernel/synchro-test.c: In function 'writer':
> kernel/synchro-test.c:311: error: dereferencing pointer to incomplete type
> kernel/synchro-test.c: In function 'downgrader':
> kernel/synchro-test.c:340: error: dereferencing pointer to incomplete type
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Acked-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  kernel/synchro-test.c |    1 +
>  1 file changed, 1 insertion(+)

Btw., locking related tests generally live in lib/.

	Ingo
