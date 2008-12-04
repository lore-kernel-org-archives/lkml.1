Return-Path: <linux-kernel-owner+w=401wt.eu-S1757367AbYLDKMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbYLDKMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 05:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbYLDKMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 05:12:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59006 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638AbYLDKMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 05:12:32 -0500
Date: Thu, 4 Dec 2008 11:12:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jianjun Kong <jianjun@zeuux.org>
Cc: rusty@rustcorp.com.au,
       Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] fix warning of not used variable
Message-ID: <20081204101223.GB18708@elte.hu>
References: <20081204010022.GB17445@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081204010022.GB17445@ubuntu>
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


* Jianjun Kong <jianjun@zeuux.org> wrote:

> 
> fix this warning:
> kernel/module.c:824: warning: ‘print_unload_info’ defined but not used
> print_unload_info() just used when CONFIG_PROC_FS was defined.
> 
> Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
> ---
>  kernel/module.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)

NAK. Warnings do not need to be "fixed", then need to be looked at and 
then there are two approaches:

 1) GCC is wrong => annotate the code
 2) GCC is right => fix the code

Your patch does not give us any idea about which case this is, whether 
you have analyzed the reason why GCC emitted that warning.

Besides, i dont see such warnings in kernel/module.c with latest GCC.

	Ingo
