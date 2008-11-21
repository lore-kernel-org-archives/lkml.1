Return-Path: <linux-kernel-owner+w=401wt.eu-S1756378AbYKUPWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbYKUPWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 10:22:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbYKUPWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 10:22:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57312 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452AbYKUPWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 10:22:33 -0500
Date: Fri, 21 Nov 2008 16:21:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: David Miller <davem@davemloft.net>, cl@linux-foundation.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       efault@gmx.de, a.p.zijlstra@chello.nl,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH] fs: pipe/sockets/anon dentries should not have a parent
Message-ID: <20081121152148.GA20388@elte.hu>
References: <Pine.LNX.4.64.0811201727070.9089@quilx.com> <20081121083044.GL16242@elte.hu> <49267694.1030506@cosmosbay.com> <20081121.010508.40225532.davem@davemloft.net> <4926AEDB.10007@cosmosbay.com> <4926D022.5060008@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4926D022.5060008@cosmosbay.com>
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


* Eric Dumazet <dada1@cosmosbay.com> wrote:

> Before patch, time to run 8 millions of close(socket()) calls on 8 
> CPUS was :
>
> real    0m27.496s
> user    0m0.657s
> sys     3m39.092s
>
> After patch :
>
> real    0m23.997s
> user    0m0.682s
> sys     3m11.193s

cool :-)

What would it take to get it down to:

>> Cost if run one one cpu :
>>
>> real    0m1.561s
>> user    0m0.092s
>> sys     0m1.469s

i guess asking for a wall-clock cost of 1.561/8 would be too much? :)

	Ingo
