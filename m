Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab0CBSet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 13:34:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54418 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250Ab0CBSer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 13:34:47 -0500
Date: Tue, 2 Mar 2010 19:34:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/1] perf archive: Don't try to collect files without a
 build-id
Message-ID: <20100302183433.GA29400@elte.hu>
References: <1267554338-9667-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267554338-9667-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> To avoid these error:
> 
>    [root@doppio ~]# perf archive
>    tar: .build-id/00/00000000000000000000000000000000000000: Cannot stat:
>    No such file or directory
>    tar: .build-id/00/00000000000000000000000000000000000000: Cannot stat:
>    No such file or directory
>    tar: .build-id/00/00000000000000000000000000000000000000: Cannot stat:
>    No such file or directory
>    tar: .build-id/00/00000000000000000000000000000000000000: Cannot stat:
>    No such file or directory
>    tar: Exiting with failure status due to previous errors
>    [root@doppio ~]#

Your fix solved the problem on my box too - thanks!

	Ingo
