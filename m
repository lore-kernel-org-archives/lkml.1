Return-Path: <linux-kernel-owner+w=401wt.eu-S1758050AbZCOJ6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbZCOJ6A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 05:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbZCOJ5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 05:57:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57741 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbZCOJ5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 05:57:50 -0400
Message-ID: <49BCD0E9.9000305@redhat.com>
Date: Sun, 15 Mar 2009 11:56:57 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Kevin Shanahan <kmshanah@ucwb.org.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
References: <9nR7rAsBwYG.A.iEG.fOCvJB@chimera> <qm8_cedJGaP.A.-NH.CPCvJB@chimera> <1237107837.27699.27.camel@kulgan.wumi.org.au> <49BCC7C8.2020503@redhat.com> <20090315094807.GB21169@elte.hu>
In-Reply-To: <20090315094807.GB21169@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> I've looked at the traces but lack the skill to make any sense 
>> out of them.
>>     
>
> Do you have specific questions about them that we could answer?
>   

A general question: what's going on?  I guess this will only be answered 
by me getting my hands dirty and understanding how ftrace works and how 
the output maps to what's happening.  I'll look at the docs for a while.

A specific question for now is how can I identify long latency within 
qemu here?  As far as I can tell all qemu latencies in trace6.txt are 
sub 100ms, which, while long, don't explain the guest stalling for many 
seconds.

-- 
error compiling committee.c: too many arguments to function

