Return-Path: <linux-kernel-owner+w=401wt.eu-S1030191AbXBFWZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030191AbXBFWZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030190AbXBFWZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:25:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44481 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030191AbXBFWZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:25:38 -0500
Date: Tue, 6 Feb 2007 23:25:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       "Lu, Yinghai" <yinghai.lu@amd.com>,
       Luigi Genoni <luigi.genoni@pirelli.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 2/2] x86_64 irq:  Handle irqs pending in IRR during irq migration.
Message-ID: <20070206222523.GA11602@elte.hu>
References: <200701221116.13154.luigi.genoni@pirelli.com> <200702021848.55921.luigi.genoni@pirelli.com> <m1ejp85tgm.fsf@ebiederm.dsl.xmission.com> <200702021905.39922.luigi.genoni@pirelli.com> <m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com> <m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com> <20070206073616.GA15016@elte.hu> <m1odo7q6cq.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1odo7q6cq.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.3 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4694]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> Ingo would it be reasonable to get a wait queue so I can wait for an 
> irq that needs the delayed disable action to actually become masked?

that might make sense, but what will do the wakeup - incidental IRQ 
arriving on the new CPU? Isnt that a bit risky - maybe the device wont 
generate IRQs for a really long time.

	Ingo
