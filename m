Return-Path: <linux-kernel-owner+w=401wt.eu-S1753680AbYAHKUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbYAHKUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 05:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbYAHKUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 05:20:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38287 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbYAHKUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 05:20:24 -0500
Date: Tue, 8 Jan 2008 11:20:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       Linux Kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org
Subject: Re: [PATCH 1/5] Codying style fixes in ./arch/x86/ia32
Message-ID: <20080108102003.GC6906@elte.hu>
References: <4d8e3fd30801070335n79d910dbt48d0ef0f3597c670@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d8e3fd30801070335n79d910dbt48d0ef0f3597c670@mail.gmail.com>
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


* Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:

>  int ia32_classify_syscall(unsigned syscall)
>  {
> -       switch(syscall) {
> +       switch (syscall) {
>         case __NR_open:
>                 return 2;
>         case __NR_openat:

this patch has whitespace damage. (tabs got converted to spaces)

i fixed this up, but the other patches in your queue are corrupted too, 
they have linewraps and tabs->spaces problems as well.

also, please use unique subjects for your patches. Instead of:

  Subject: Codying style fixes in ./arch/x86/ia32

use:

  Subject: x86: coding style fixes in arch/x86/ia32/audit.c

(also please keep them lower case)

	Ingo
