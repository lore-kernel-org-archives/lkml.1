Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884AbZFDTpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbZFDTpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 15:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbZFDTpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 15:45:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38164 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbZFDTpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 15:45:45 -0400
Date: Thu, 4 Jun 2009 21:45:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perfcounter: don't keep warnings treated as errors as
	default
Message-ID: <20090604194532.GA24606@elte.hu>
References: <1244135688-5542-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1244135688-5542-1-git-send-email-fweisbec@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Building userspace perfcounter tools gives such warning:
> 
> cc1: warnings being treated as errors
> builtin-top.c: In function ‘print_sym_table’:
> builtin-top.c:207: erreur: ignoring return value of ‘write’, declared with attribute warn_unused_result
> make: *** [builtin-top.o] Erreur 1

I've fixed this by changing that line to puts(CONSOLE_CLEAR) (folded 
that into your other patch). Do you get any other warnings? We want 
to fix them really.

	Ingo
