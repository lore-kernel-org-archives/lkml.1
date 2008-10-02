Return-Path: <linux-kernel-owner+w=401wt.eu-S1753695AbYJBJ0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbYJBJ0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 05:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbYJBJ0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 05:26:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50565 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbYJBJ0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 05:26:43 -0400
Date: Thu, 2 Oct 2008 11:26:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Typo bug [Re: Linux 2.6.27-rc8]
Message-ID: <20081002092630.GB9456@elte.hu>
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org> <20080930094346.307ef1e5@werewolf.home> <20080930075553.GB20241@elte.hu> <20080930100252.22bb4df5@werewolf.home> <20080930080546.GD20241@elte.hu> <20081001213328.GB7115@tilt.dandreoli.com> <20081002052746.GI24654@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081002052746.GI24654@1wt.eu>
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


* Willy Tarreau <w@1wt.eu> wrote:

> On Wed, Oct 01, 2008 at 11:33:28PM +0200, Domenico Andreoli wrote:
> > On Tue, Sep 30, 2008 at 10:05:46AM +0200, Ingo Molnar wrote:
> > > 
> > > * J.A. Magallón <jamagallon@ono.com> wrote:
> > > 
> > > > > heh. Could you send a patch with a changelog please?
> > > > 
> > > > Here it goes...I hope its right.
> > > 
> > > applied to tip/x86/urgent, thanks!
> > 
> > Ingo, why did you require a patch? Was not it really more simple and
> > easy for everyone to write it yourself? Since I am sure it was not only
> > a laziness matter (really?), I am very curious to know the reason.
> 
> I see two things :
>   - preserve authorship of the code
>   - "laziness" as you call it, is the only way to scale for a maintainer.

yeah, correct. Also, i asked (not required) J.A. Magallón whether he 
could send a patch - if he didnt (no time, etc.) i'd have fixed it 
myself (crediting him in the changelog).

But it's also a general principle: maintainers dont 'own' the code in 
any way and there should be no assymetry in the ability to modify the 
code. So if people are willing to fix bugs they notice, i prefer that 
far more than me doing it.

	Ingo
