Return-Path: <linux-kernel-owner+w=401wt.eu-S1757136AbZA2SwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136AbZA2SwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 13:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbZA2Sv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 13:51:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33822 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468AbZA2Sv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 13:51:56 -0500
Date: Thu, 29 Jan 2009 19:51:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH -next/mmotm/resend] kmemtrace: fix printk formats
Message-ID: <20090129185145.GB14810@elte.hu>
References: <200901291030.n0TAUhRI003046@imap1.linux-foundation.org> <4981E86F.60909@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4981E86F.60909@oracle.com>
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
> Fix kmemtrace printk warnings:
> 
> kernel/trace/kmemtrace.c:142: warning: format '%4ld' expects type 'long int', but argument 3 has type 'size_t'
> kernel/trace/kmemtrace.c:147: warning: format '%4ld' expects type 'long int', but argument 3 has type 'size_t'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> cc:      Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> ---
>  kernel/trace/kmemtrace.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

it's in tip/tracing already, i applied it 6 days ago.

	Ingo
