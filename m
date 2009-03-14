Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbZCNLTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbZCNLTd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 07:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbZCNLTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 07:19:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50390 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754340AbZCNLTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 07:19:23 -0400
Date: Sat, 14 Mar 2009 12:18:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mtrr] x86: more MTRR debug printouts
Message-ID: <20090314111851.GA24536@elte.hu>
References: <49B9BA5A.40108@kernel.org> <tip-8ad9790588ee2e69118b2b294ddab6f3f0379ad9@git.kernel.org> <1236958403.2646.1.camel@ht.satnam> <1236959121.2646.3.camel@ht.satnam> <49BAB7FF.4030107@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49BAB7FF.4030107@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> +	preempt_disable();
> +	cpu = smp_processor_id();

in such cases it's better to use a get_cpu() / put_cpu() 
construct.

	Ingo
