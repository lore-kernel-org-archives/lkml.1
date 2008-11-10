Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbYKJJfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbYKJJfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 04:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbYKJJfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 04:35:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35146 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478AbYKJJf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 04:35:29 -0500
Date: Mon, 10 Nov 2008 10:35:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <Jens.Axboe@oracle.com>
Subject: Re: [PATCH] fix smp generic helper voyager breakage
Message-ID: <20081110093516.GK22392@elte.hu>
References: <1225400980.19324.24.camel@localhost.localdomain> <20081030215421.GG30303@elte.hu> <1225404368.19324.49.camel@localhost.localdomain> <20081030222111.GA18600@elte.hu> <1226253194.19841.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226253194.19841.9.camel@localhost.localdomain>
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

> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date: Wed, 29 Oct 2008 14:53:06 -0500
> Subject: [VOYAGER] fix generic smp helpers non compile

hm, i reported a bug to you with this patch on Oct 30.

> commit 3d4422332711ef48ef0f132f1fcbfcbd56c7f3d1
> Author: Jens Axboe <jens.axboe@oracle.com>
> Date:   Thu Jun 26 11:21:34 2008 +0200
> 
>     Add generic helpers for arch IPI function calls
> 
> didn't wire up the voyager smp call function correctly, so do that
> here.  Also make CONFIG_USE_GENERIC_SMP_HELPERS a def_bool y again,
> since we now use the generic helpers for every x86 architecture.
> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>  arch/x86/Kconfig                    |    5 ++++-
>  arch/x86/mach-voyager/voyager_smp.c |   16 ++++++++++++++--
>  2 files changed, 18 insertions(+), 3 deletions(-)

no indication in the changelog whether that bug i reported got fixed - 
did it? (i suspect it did, but not sure)

	Ingo
