Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbXJXCMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbXJXCMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 22:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbXJXCMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 22:12:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45927 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803AbXJXCMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 22:12:06 -0400
Message-ID: <471EA9D6.9000004@garzik.org>
Date: Tue, 23 Oct 2007 22:11:34 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: akpm@linux-foundation.org, torvalds@linux-foundation.org, matthew@wil.cx,
       arnd@arndb.de, ralf@linux-mips.org, adobriyan@gmail.com,
       viro@ftp.linux.org.uk, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/2] irq_flags_t: intro and core annotations
References: <E1IkAWI-0006vX-00@gondolin.me.apana.org.au>
In-Reply-To: <E1IkAWI-0006vX-00@gondolin.me.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> Jeff Garzik <jeff@garzik.org> wrote:
>> Let me add to the chorus of voices:  I continually see two cases where 
>> real bugs crop up:
>>
>> 1) hacker uses spin_lock_irq() in incorrect context (where it is not 
>> safe to do a blind enable/disable)
>>
>> 2) hacker uses spin_lock_irq() correctly, but the surrounding code 
>> changes, thus invalidating prior assumptions.
>>
>> I would even go so far as to support the drastic measure of deleting 
>> spin_lock_irq().
>>
>> spin_lock_irqsave() generates fewer bugs, is more future-proof, and by 
>> virtue of 'flags' permits architectures a bit more flexibility.
> 
> Could we add a debug option that warned if spin_lock_irq is
> executed with IRQs turned off already?

Seems reasonable but perhaps arch-specific?

Also, I think someone (akpm?) mentioned an effort had been made before, 
and run into some problems.  I don't have details...

	Jeff



