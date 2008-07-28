Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbYG1PJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbYG1PJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYG1PJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 11:09:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38470 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbYG1PJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 11:09:00 -0400
Date: Mon, 28 Jul 2008 17:08:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Mark McLoughlin <markmc@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: call early_cpu_init at the same point
Message-ID: <20080728150844.GD32111@elte.hu>
References: <488520A2.1080701@goop.org> <20080724102856.GB28817@elte.hu> <4888A410.3020108@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4888A410.3020108@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0431]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>
>>   
>>> Call early_cpu_init() at the same (early) point in setup_arch(). The  
>>> x86_64 code was calling it relatively late, after when other arch 
>>> code need to do cpu-related setup which depends on it.
>>>     
>>
>> applied to tip/x86/urgent, thanks Jeremy.
>
> Thanks.  Curious to see if this causes any breakage, especially in 
> numa-ish type systems.

no badness so far.

	Ingo
