Return-Path: <linux-kernel-owner+w=401wt.eu-S1755076AbZESPBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbZESPBG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 11:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbZESPAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 11:00:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60822 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbZESPAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 11:00:54 -0400
Date: Tue, 19 May 2009 17:00:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Li Wei <W.Li@Sun.COM>, Michael Ellerman <michaele@au1.ibm.com>,
       Heiko Carstens <heicars2@linux.vnet.ibm.com>,
       Martin Schwidefsky <mschwid2@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/4] gcov: add gcov profiling infrastructure
Message-ID: <20090519150031.GA21271@elte.hu>
References: <20090519142416.356254359@linux.vnet.ibm.com> <20090519142418.583158351@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090519142418.583158351@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:

> +int __gcov_execve(const char *path, char *const argv[], char *const envp[])
> +{
> +	return kernel_execve(path, argv, envp);
> +}
> +EXPORT_SYMBOL(__gcov_execve);

Looks weird, why is this needed?

	Ingo
