Return-Path: <linux-kernel-owner+w=401wt.eu-S1758248AbXLQPTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248AbXLQPTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 10:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757506AbXLQPTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 10:19:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59534 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757485AbXLQPTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 10:19:11 -0500
Date: Mon, 17 Dec 2007 16:16:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Ben Woodard <woodard@redhat.com>, Neil Horman <nhorman@redhat.com>,
       kexec@lists.infradead.org, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       Andi Kleen <andi@firstfloor.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on
	boot cpu
Message-ID: <20071217151642.GA25081@elte.hu>
References: <20071211192434.GD10999@hmsreliant.think-freely.org> <86802c440712111151t29acd38kf9fac8e41743f3e4@mail.gmail.com> <20071211205955.GF10999@hmsreliant.think-freely.org> <20071212142132.GC4889@bingen.suse.de> <20071212155515.GA29735@hmsendeavour.rdu.redhat.com> <20071212160722.GD4889@bingen.suse.de> <m1prxbu2ah.fsf@ebiederm.dsl.xmission.com> <20071212202215.GB29735@hmsendeavour.rdu.redhat.com> <m1lk7ztx9p.fsf@ebiederm.dsl.xmission.com> <20071213143922.GA4674@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213143922.GA4674@hmsreliant.think-freely.org>
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


* Neil Horman <nhorman@tuxdriver.com> wrote:

> Ok, new patch attached, taking into account Andi's request for a 
> cleaner method to implement single application quirks.  I've spoken 
> with Ben, who is continuing to retest, and reports that clean 
> methodical testing results in success with this patch.

thanks, i've added your patch to x86.git#mm - queued up for v2.6.25 
merging. But v2.6.24 merging would be too risky i think: it's not a 
regression fix and for a regular fix it's a bit late in the cycle for a 
bugfix that changes so many aspects of the early quirk code.

	Ingo
