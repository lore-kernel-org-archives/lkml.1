Return-Path: <linux-kernel-owner+w=401wt.eu-S1758068AbYKWKDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbYKWKDS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 05:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbYKWKDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 05:03:01 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42354 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbYKWKDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 05:03:00 -0500
Date: Sun, 23 Nov 2008 11:02:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hannes Eder <hannes@hanneseder.net>
Cc: Alok N Kataria <akataria@vmware.com>, Dan Hecht <dhecht@vmware.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: vmware - fix sparse warnings
Message-ID: <20081123100249.GV30453@elte.hu>
References: <154e089b0811211417l7c6c5cf8j7e248399fa7ebd20@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154e089b0811211417l7c6c5cf8j7e248399fa7ebd20@mail.gmail.com>
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
> arch/x86/kernel/cpu/vmware.c:69:5: warning: symbol 'vmware_platform'
> was not declared. Should it be static?
> arch/x86/kernel/cpu/vmware.c:89:15: warning: symbol
> 'vmware_get_tsc_khz' was not declared. Should it be static?
> arch/x86/kernel/cpu/vmware.c:107:16: warning: symbol
> 'vmware_set_feature_bits' was not declared. Should it be static?
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> ---
>  arch/x86/kernel/cpu/vmware.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

applied to tip/x86/detect-hyper, thanks Hannes!

	Ingo
