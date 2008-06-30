Return-Path: <linux-kernel-owner+w=401wt.eu-S1763438AbYF3SFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763438AbYF3SFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763289AbYF3SFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:05:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43559 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763281AbYF3SFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:05:36 -0400
Date: Mon, 30 Jun 2008 20:05:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       mingo <mingo@redhat.com>, tglx <tglx@linutronix.de>,
       hpa <hpa@zytor.com>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] fork and exit: need to include iocontext.h
Message-ID: <20080630180506.GC23739@elte.hu>
References: <20080630105458.7c95e195.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630105458.7c95e195.randy.dunlap@oracle.com>
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


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix fork and exit build errors: they need to include iocontext.h:
> 
> linux-next-20080630/kernel/fork.c: In function 'copy_process':
> linux-next-20080630/kernel/fork.c:1237: error: implicit declaration of function 'put_io_context'
> linux-next-20080630/kernel/exit.c: In function 'do_exit':
> linux-next-20080630/kernel/exit.c:992: error: implicit declaration of function 'exit_io_context'

i havent seen this one - do you know by chance which commit triggers it?

	Ingo
