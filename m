Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbZBEO6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbZBEO6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 09:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZBEO6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 09:58:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42095 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbZBEO6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 09:58:02 -0500
Date: Thu, 5 Feb 2009 15:57:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 1/3] xen: setup percpu data pointers
Message-ID: <20090205145741.GC23903@elte.hu>
References: <49876BD3.5070804@goop.org> <498A8738.9050200@gmail.com> <498A8C05.30704@kernel.org> <498A9284.8050805@goop.org> <498ABFA9.7060203@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498ABFA9.7060203@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Jeremy Fitzhardinge wrote:
> > Tejun Heo wrote:
> >> Tejun Heo wrote:
> >>  
> >>> Applied 1-3 to #tj-percpu with trivial modification on #2 (will reply
> >>> to the message).
> >>>     
> >>
> >> Oh... hpa already merged them into x86/paravirt.  I'll just pull
> >> x86/paravirt into core/percpu because the first patch needs to be in
> >> core/percpu to keep xen working.
> >>
> >> hpa, can you please take the other xen patch[1] into x86/paravirt too?
> >> So that I can receive it via you?
> > 
> > Looks like its already there.
> 
> Yes, right, which means tj-percpu == x86/paravirt for the time being.
> Ingo, please pull from the following to fast forward core/percpu to
> x86/paravirt (or you can just do it yourself :-)
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

done, thanks Tejun. Testing results look good so far.

	Ingo
