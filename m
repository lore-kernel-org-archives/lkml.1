Return-Path: <linux-kernel-owner+w=401wt.eu-S936263AbXHIJKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936263AbXHIJKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 05:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765986AbXHIJKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 05:10:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:51672 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765290AbXHIJKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 05:10:31 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] make atomic_t volatile on all architectures
To: Jerry Jiang <wjiang@resilience.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, akpm@linux-foundation.org, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       cfriesen@nortel.com, zlynx@acm.org
Reply-To: 7eggert@gmx.de
Date: Thu, 09 Aug 2007 11:10:16 +0200
References: <8Q2Pg-8uV-23@gated-at.bofh.it> <8Q7Fa-7rJ-1@gated-at.bofh.it> <8Q8rD-hh-7@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1IJ424-0000d7-HK@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX180J9JAtnnMfWTTpuokb4qhxBNpzg/pduJ+7UI
 xLKqfMVyGNfpkNGlSNM5kbp2xhe5JEf7H1vOiTZZUYzDOKdEzk
 jKIsbzP0JoJPE+Sj0Vs1Q==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jerry Jiang <wjiang@resilience.com> wrote:
> On Wed, 8 Aug 2007 21:18:25 -0700 (PDT)
>> On Wed, 8 Aug 2007, Chris Snook wrote:

>> > Some architectures currently do not declare the contents of an atomic_t to
>> > be
>> > volatile.  This causes confusion since atomic_read() might not actually
>> > read anything if an optimizing compiler re-uses a value stored in a
>> > register, which can break code that loops until something external changes
>> > the value of an atomic_t.
>> 
>> I'd be *much* happier with "atomic_read()" doing the "volatile" instead.
>> 
>> The fact is, volatile on data structures is a bug. It's a wart in the C
>> language. It shouldn't be used.
> 
> Why? It's a wart! Is it due to unclear C standard on volatile related point?
> 
> Why the *volatile-accesses-in-code* is acceptable, does C standard make it
> clear?

http://lwn.net/Articles/233482/
-- 
Fun things to slip into your budget
Heisenberg Compensator upgrade kit

Friﬂ, Spammer: uWfuXeviZ@x.7eggert.dyndns.org
