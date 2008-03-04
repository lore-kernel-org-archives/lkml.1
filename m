Return-Path: <linux-kernel-owner+w=401wt.eu-S1765270AbYCDQPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765270AbYCDQPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760180AbYCDQPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:15:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58053 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759944AbYCDQPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:15:46 -0500
Date: Tue, 4 Mar 2008 17:15:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Mark McLoughlin <markmc@redhat.com>, Ian Campbell <ijc@hellion.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] use realmode code to reserve end-of-conventional-memory
	to 1MB
Message-ID: <20080304161510.GB13696@elte.hu>
References: <20080228131341.GA25213@mailshack.com> <20080228132822.GA25278@mailshack.com> <1204233131.28798.12.camel@cthulhu.hellion.org.uk> <47C72432.3010606@zytor.com> <1204240609.28798.33.camel@cthulhu.hellion.org.uk> <1204630906.16613.4.camel@muff> <20080304143324.GA2713@elte.hu> <47CD672C.1040406@goop.org> <20080304152540.GC6449@elte.hu> <47CD7290.1040907@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CD7290.1040907@goop.org>
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
>>> I think it was a side effect of all the early_ioremap work, which changed 
>>> the order in which things happened at boot time.
>>>     
>>
>> which commits do you mean in particular?
>
> Good question.  It might have been cpa as well.  I'd have to look 
> through to confirm the theory, but I think Xen got broken for other 
> reasons around there, so simple bisect wouldn't be enough to identify 
> the problem.

i'm trying to do bug forensics to figure out where we broke Xen - i 
really have the feeling that there could be other side-effects of 
whatever change caused this.

	Ingo
