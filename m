Return-Path: <linux-kernel-owner+w=401wt.eu-S1757882AbYBOIFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882AbYBOIFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 03:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbYBOIFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 03:05:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42488 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbYBOIFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 03:05:19 -0500
Date: Fri, 15 Feb 2008 09:04:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 updates
Message-ID: <20080215080433.GA12341@elte.hu>
References: <20080213155725.GA19523@elte.hu> <661de9470802130819i61dfe317jf3725a49d8a314b4@mail.gmail.com> <20080214162510.GA29570@elte.hu> <47B47D85.9070504@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B47D85.9070504@qumranet.com>
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


* Avi Kivity <avi@qumranet.com> wrote:

>> thanks, applied - this first looked like a KVM item, that's why i 
>> havent added it. [Btw., feel free to push it via kvm.git as well - as 
>> long as you are sure it does not break the build ;-) ]
>
> Yeah, I'm queuing it as well, it will get there one way or the other.

x86.git won that race ;-)

i've had a good deal of build testing done with that patch and there's 
no [bzImage-level] build breakage that i can report. Which is not a 
surprise, the quality of arch/x86/kvm/ is outstandingly high:

  $ code-quality arch/x86/kvm/

                               errors   lines of code   errors/KLOC
  arch/x86/kvm/                    29           14566           1.9

as a comparison:

                               errors   lines of code   errors/KLOC
  kernel/                         729           92796           7.8

see: http://redhat.com/~mingo/x86.git/code-quality . It's as arbitrary 
of a metric as all static code metrics, but the numbers it emits are 
surprisingly close to my personal estimation of the cleanliness of some 
in-kernel codebases i ran it again.

[ hint, try "code-quality kernel/sched.c" too ;-) ]

	Ingo
