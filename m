Return-Path: <linux-kernel-owner+w=401wt.eu-S1761501AbZAOSrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761501AbZAOSrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 13:47:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZAOSrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 13:47:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53330 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404AbZAOSra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 13:47:30 -0500
Date: Thu, 15 Jan 2009 19:46:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>,
       ebiederm@xmission.com, cl@linux-foundation.org, rusty@rustcorp.com.au,
       travis@sgi.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       steiner@sgi.com, hugh@veritas.com
Subject: Re: [PATCH] percpu: add optimized generic percpu accessors
Message-ID: <20090115184625.GA9944@elte.hu>
References: <496C9FB7.9050907@kernel.org> <496D8CEB.5060402@zytor.com> <20090114093834.GA19799@elte.hu> <496F0F50.6070200@kernel.org> <20090115113045.GG22850@elte.hu> <496F2032.5080502@kernel.org> <20090115122611.GJ22850@elte.hu> <496F346B.6020804@kernel.org> <20090115130740.GE21839@elte.hu> <496F38C7.5000403@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496F38C7.5000403@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0416]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> 
> It is an optimization and a cleanup, and adds the following new
> generic percpu methods:
> 
>   percpu_read()
>   percpu_write()
>   percpu_add()
>   percpu_sub()
>   percpu_and()
>   percpu_or()
>   percpu_xor()

on a second thought ... i just started using this construct in code, and 
promptly typoed it: i typed "per_cpu_read()".

Which is really the more logical name for this. Mind if i do a 
s/percpu/per_cpu/ rename of all of these new APIs?

	Ingo
