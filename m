Return-Path: <linux-kernel-owner+w=401wt.eu-S1762361AbYEFOls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762361AbYEFOls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 10:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754977AbYEFOlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 10:41:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48109 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099AbYEFOlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 10:41:40 -0400
Date: Tue, 6 May 2008 16:41:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       jkosina@suse.cz, zdenek.kabelac@gmail.com
Subject: Re: [PATCH REPOST^3] Run IST traps from user mode preemptive on
	process stack
Message-ID: <20080506144127.GB26281@elte.hu>
References: <20080502091948.GA26099@basil.nowhere.org> <alpine.LFD.1.10.0805061305460.3318@apollo.tec.linutronix.de> <87skwvbn4m.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87skwvbn4m.fsf@basil.nowhere.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> Thomas Gleixner <tglx@linutronix.de> writes:
> 
> > On Fri, 2 May 2008, Andi Kleen wrote:
> >> [Fixes a bug originally introduced in 2.6.23 I think. Reposted many times
> >> so far, but still not applied. Please apply.]
> >
> > The print_vma_addr() bug was introduced by commit 03252919 (by you) in
> > the 2.6.25 merge window and we fixed it before 25-rc2 via commit e8bff74a.

hm, why did you cut out and ignore this question from Thomas:

> > Do you know about any other breakage in that code? If not, why do 
> > you claim that we ignored a bug fix?

First you are putting pressure on us by innuendo that we somehow did not 
react to an unfixed x86 bug, supposedly starting in v2.6.23 and still 
not fixed in v2.6.26 as we speak. This is a pretty serious accusation!

But, if one looks closer, your accusation does not hold up to scrutiny: 
it turns out that it is not in v2.6.23 but v2.6.25, that it got fixed 
within 2 weeks between v2.6.25-rc1 and v2.6.25-rc2, that it is not an 
unfixed bug that we ignored but at most about a small detail in a debug 
feature introduced by _you_.

Why are you doing this with us? First you are accusing us and then you 
are ignoring straight questions that would clear us from your unfair 
accusation. Why?

	Ingo
