Return-Path: <linux-kernel-owner+w=401wt.eu-S1752779AbYJ2HET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbYJ2HET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 03:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbYJ2HEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 03:04:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48299 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbYJ2HED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 03:04:03 -0400
Date: Wed, 29 Oct 2008 08:03:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: two trivial sparse annotations
Message-ID: <20081029070357.GE7936@elte.hu>
References: <1225260322.20276.2.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225260322.20276.2.camel@brick>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> arch/x86/kernel/vsmp_64.c:87:14: warning: incorrect type in argument 1 (different address spaces)
> arch/x86/kernel/vsmp_64.c:87:14:    expected void const volatile [noderef] <asn:2>*addr
> arch/x86/kernel/vsmp_64.c:87:14:    got void *[assigned] address
> arch/x86/kernel/vsmp_64.c:88:22: warning: incorrect type in argument 1 (different address spaces)
> arch/x86/kernel/vsmp_64.c:88:22:    expected void const volatile [noderef] <asn:2>*addr
> arch/x86/kernel/vsmp_64.c:88:22:    got void *
> arch/x86/kernel/vsmp_64.c:100:23: warning: incorrect type in argument 2 (different address spaces)
> arch/x86/kernel/vsmp_64.c:100:23:    expected void volatile [noderef] <asn:2>*addr
> arch/x86/kernel/vsmp_64.c:100:23:    got void *
> arch/x86/kernel/vsmp_64.c:101:23: warning: incorrect type in argument 1 (different address spaces)
> arch/x86/kernel/vsmp_64.c:101:23:    expected void const volatile [noderef] <asn:2>*addr
> arch/x86/kernel/vsmp_64.c:101:23:    got void *
> arch/x86/mm/gup.c:235:6: warning: incorrect type in argument 1 (different base types)
> arch/x86/mm/gup.c:235:6:    expected void const volatile [noderef] <asn:1>*<noident>
> arch/x86/mm/gup.c:235:6:    got unsigned long [unsigned] [assigned] start
> 
> Impact: fewer sparse warnings, no functional changes
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  arch/x86/kernel/vsmp_64.c |    2 +-
>  arch/x86/mm/gup.c         |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

applied to tip/x86/urgent, thanks Harvey!

i see you started using the impact-line, nice :) I moved it to the top 
of the commit, that's where we generally put it. (it acts as a 
secondary subject line in essence, so sits right next to the first 
line of the commit)

	Ingo
