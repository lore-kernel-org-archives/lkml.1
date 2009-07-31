Return-Path: <linux-kernel-owner+w=401wt.eu-S1752291AbZGaMSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbZGaMSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 08:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbZGaMSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 08:18:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53810 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbZGaMSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 08:18:36 -0400
Date: Fri, 31 Jul 2009 14:18:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
       lethal@linux-sh.org, tglx@linutronix.de, akpm@linux-foundation.org
Subject: Re: [PATCH] clocksource: save mult_orig in clocksource_disable()
Message-ID: <20090731121811.GA3989@elte.hu>
References: <20090618152432.10136.9932.sendpatchset@rx1.opensource.se> <1245352632.7508.1.camel@localhost.localdomain> <aec7e5c30906252230s62196e1fr5671aa591f1869a3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aec7e5c30906252230s62196e1fr5671aa591f1869a3@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Magnus Damm <magnus.damm@gmail.com> wrote:

> On Fri, Jun 19, 2009 at 4:17 AM, john stultz<johnstul@us.ibm.com> wrote:
> > On Fri, 2009-06-19 at 00:24 +0900, Magnus Damm wrote:
> >> From: Magnus Damm <damm@igel.co.jp>
> >>
> >> Save clocksource mult_orig in clocksource_disable().
> >>
> >> To fix the common case where ->enable() does not setup
> >> mult, make sure mult_orig is saved in mult on disable.
> >>
> >> Also add comments to explain why we do this.
> >>
> >> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> >
> > Acked-by: John Stultz <johnstul@us.ibm.com>
> >
> > Thomas, Andrew, please push this for 2.6.31.
> 
> This one is slowly making it's way in I suppose?

Btw., what specific issue does this fix? The commit description is 
generic, there's no bugzilla link and no other information either 
that could give me an idea about precisely what incarnation of the 
bug you have hit.

Thanks,

	Ingo
