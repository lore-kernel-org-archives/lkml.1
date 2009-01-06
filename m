Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543AbZAFP2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbZAFP2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 10:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbZAFP2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 10:28:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41175 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbZAFP2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 10:28:39 -0500
Date: Tue, 6 Jan 2009 16:28:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>, Nick Piggin <npiggin@suse.de>,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Cliff Wickman <cpw@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: Re: [patch] x86: make UV support optional
Message-ID: <20090106152823.GB11114@elte.hu>
References: <20090106060348.GA16738@wotan.suse.de> <20090106143330.GB18913@sgi.com> <49637090.8010501@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49637090.8010501@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> @@ -616,6 +616,7 @@ config MAXSMP
>  	bool "Configure Maximum number of SMP Processors and NUMA Nodes"
>  	depends on X86_64 && SMP && DEBUG_KERNEL && EXPERIMENTAL
>  	select CPUMASK_OFFSTACK
> +	select X86_UV
>  	default n
>  	help

why not add this to X86_UV:

	default MAXSMP

this way it still stays fully configurable, but it is default-enabled if 
someone strives for a big SMP kernel.

	Ingo
