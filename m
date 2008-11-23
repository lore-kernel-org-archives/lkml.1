Return-Path: <linux-kernel-owner+w=401wt.eu-S1758210AbYKWKMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbYKWKMc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 05:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbYKWKMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 05:12:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32986 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbYKWKMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 05:12:21 -0500
Date: Sun, 23 Nov 2008 11:12:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hannes Eder <hannes@hanneseder.net>
Cc: Alok N Kataria <akataria@vmware.com>, Dan Hecht <dhecht@vmware.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: hypervisor - fix sparse warnings
Message-ID: <20081123101209.GA30453@elte.hu>
References: <154e089b0811211356y79981d6cke1ea8bf3eddf7e50@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154e089b0811211356y79981d6cke1ea8bf3eddf7e50@mail.gmail.com>
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


* Hannes Eder <hannes@hanneseder.net> wrote:

> Fix the following sparse warnings:
> 
> arch/x86/kernel/cpu/hypervisor.c:37:15: warning: symbol
> 'get_hypervisor_tsc_freq' was not declared. Should it be static?
> arch/x86/kernel/cpu/hypervisor.c:53:16: warning: symbol
> 'init_hypervisor' was not declared. Should it be static?
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> ---
>  arch/x86/kernel/cpu/hypervisor.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

applied to tip/x86/detect-hyper, thanks Hannes!

	Ingo
