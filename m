Return-Path: <linux-kernel-owner+w=401wt.eu-S1757485AbYEPNGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbYEPNGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 09:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754978AbYEPNGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 09:06:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52760 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131AbYEPNGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 09:06:35 -0400
Date: Fri, 16 May 2008 15:06:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jan Beulich <jbeulich@novell.com>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/xen: fix arbitrary_virt_to_machine()
Message-ID: <20080516130616.GA24815@elte.hu>
References: <482C47B4.76E4.0078.0@novell.com> <482C3360.1040309@goop.org> <20080516120911.GE11718@elte.hu> <482D8585.90909@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482D8585.90909@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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
>>  	unsigned int level;
>>  	pte_t *pte = lookup_address(address, &level);
>> -	unsigned offset = address & PAGE_MASK;
>> +	unsigned offset = address & ~PAGE_SIZE;
>>   
>
> Ah, no, you have the worst of both worlds there ;)  Should be ~PAGE_*MASK*.

argh :-) fixed.

	Ingo
