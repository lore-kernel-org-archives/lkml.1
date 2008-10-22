Return-Path: <linux-kernel-owner+w=401wt.eu-S1754350AbYJVMDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbYJVMDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 08:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbYJVMDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 08:03:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48940 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbYJVMDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 08:03:07 -0400
Date: Wed, 22 Oct 2008 14:02:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, hbabu@us.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: make oops_begin and oops_end equal
Message-ID: <20081022120222.GE8095@elte.hu>
References: <20081017210013.GD23591@hmsreliant.think-freely.org> <20081020121339.GE10594@elte.hu> <20081020134211.GA15574@hmsreliant.think-freely.org> <20081020150731.GA25999@mailshack.com> <20081020150834.GA26018@mailshack.com> <20081021144505.GA25750@hmsreliant.think-freely.org> <1224670721.25843.1280616145@webmail.messagingengine.com> <20081022104513.GA18951@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022104513.GA18951@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Neil Horman <nhorman@tuxdriver.com> wrote:

> > Thanks for the review. I've sent a redone patch series just a moment 
> > ago, based on your comments. There was also another problem with 
> > these two patches: oops_end(flags, regs, signr) had special 
> > behaviour for regs=NULL that I did not consider before. The series 
> > has grown due to this issue...

[...]
> Copy that.  Thanks for the quick turn-around.

applied to tip/x86/dumpstack, thanks guys!

Could you please also create arch/x86/kernel/dumpstack.c and move all 
the now-unified bits there - before they get out of sync again?

	Ingo
