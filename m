Return-Path: <linux-kernel-owner+w=401wt.eu-S1753466AbYIXH7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbYIXH7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 03:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbYIXH7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 03:59:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41614 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbYIXH7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 03:59:09 -0400
Date: Wed, 24 Sep 2008 09:58:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] x86: ds.c ptrace.c integer as NULL pointer sparse fixes
Message-ID: <20080924075854.GA19354@elte.hu>
References: <1222207004.16003.20.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222207004.16003.20.camel@brick>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0006]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> arch/x86/kernel/ptrace.c:763:29: warning: Using plain integer as NULL pointer
> arch/x86/kernel/ptrace.c:777:46: warning: Using plain integer as NULL pointer
> arch/x86/kernel/ptrace.c:1115:45: warning: Using plain integer as NULL pointer
> arch/x86/kernel/ds.c:482:26: warning: Using plain integer as NULL pointer
> arch/x86/kernel/ds.c:487:25: warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
>
> ---
>  arch/x86/kernel/ds.c     |    4 ++--
>  arch/x86/kernel/ptrace.c |    6 +++---
>  2 files changed, 5 insertions(+), 5 deletions(-)

applied to tip/x86/pebs, thanks Harvey!

	Ingo
