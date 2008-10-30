Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbYJ3VXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbYJ3VXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbYJ3VXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:23:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50695 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533AbYJ3VXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:23:10 -0400
Date: Thu, 30 Oct 2008 22:22:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Glauber Costa <gcosta@redhat.com>
Subject: Re: [PATCH] fix boot breakage caused by x86: boot secondary cpus
	through initial_code
Message-ID: <20081030212259.GB30303@elte.hu>
References: <1225400918.19324.23.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225400918.19324.23.camel@localhost.localdomain>
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


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> >From 01d1cd30acbcdab745ebc90c73d5fa4a27ce1d5c Mon Sep 17 00:00:00 2001
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date: Wed, 29 Oct 2008 14:50:04 -0500
> Subject: [VOYAGER] make non boot CPUs work again
> 
> This commit:
> 
> commit 3e9704739daf46a8ba6593d749c67b5f7cd633d2
> Author: Glauber Costa <gcosta@redhat.com>
> Date:   Wed May 28 13:01:54 2008 -0300
> 
>     x86: boot secondary cpus through initial_code
> 
> removed the use of initialize_secondary.  However, it didn't update
> voyager, so the secondary cpus no longer boot.  Fix this by adding the
> initial_code switch to voyager as well.
> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>  arch/x86/mach-voyager/voyager_smp.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)

applied to tip/x86/urgent, thanks James!

	Ingo
