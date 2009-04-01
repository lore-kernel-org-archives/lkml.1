Return-Path: <linux-kernel-owner+w=401wt.eu-S1765767AbZDAQpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765767AbZDAQpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 12:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756288AbZDAQpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 12:45:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39796 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755862AbZDAQpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 12:45:08 -0400
Date: Wed, 1 Apr 2009 18:44:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Tejun Heo <htejun@gmail.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Joe Perches <joe@perches.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] x86: percpu_to_op() misses memory and flags clobbers
Message-ID: <20090401164447.GA16626@elte.hu>
References: <49D32212.80607@cosmosbay.com> <49D32DC2.9010003@goop.org> <49D33E80.70802@cosmosbay.com> <20090401161218.GB3859@elte.hu> <49D39940.80801@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D39940.80801@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>>>                      : "memory", "cc");
>>> }
>>>     
>>
>> Hm, what's your point with pasting this inline function?
>>   
>
> He's pointing out the redundant (but harmless) "cc" clobber.

ah, yes. We are completely inconsistent about that. It doesnt
matter on x86 so i guess could be removed everywhere.

	Ingo
