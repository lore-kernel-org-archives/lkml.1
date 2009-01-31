Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbZAaAzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbZAaAzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 19:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbZAaAzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 19:55:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54970 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797AbZAaAzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 19:55:00 -0500
Date: Sat, 31 Jan 2009 01:54:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Tejun Heo <tj@kernel.org>,
       paulmck@linux.vnet.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Brian Gerst <brgerst@gmail.com>
Subject: Re: Seeing "huh, entered softirq 8 ffffffff802682aa preempt_count
	00000100, exited with 00010100?" in tip.git
Message-ID: <20090131005445.GB21022@elte.hu>
References: <498229CF.1090007@goop.org> <20090130005953.GD6716@linux.vnet.ibm.com> <49825B8B.2000202@goop.org> <20090130150859.GB27549@elte.hu> <20090130221747.GA6877@elte.hu> <20090130223455.GA4151@elte.hu> <49839FCB.3010509@goop.org> <4983A00F.5040505@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4983A00F.5040505@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> Jeremy Fitzhardinge wrote:
>>
>> I found my bug.  Turns out all my CPUs were sharing the same kernel  
>> stack (!), which means it was working surprisingly well, considering...
>>
>
> ROTFLMAO!

muhaha. I wrote such a bug only once in my whole life - back when we wrote 
the first version of the Linux SMP code, more than a decade ago. It was a 
lot of fun to debug - the exact point and nature of the crash changed as i 
added printks to the bootup code ;-)

	Ingo
