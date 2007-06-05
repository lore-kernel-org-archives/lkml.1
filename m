Return-Path: <linux-kernel-owner+w=401wt.eu-S1764216AbXFEJui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764216AbXFEJui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 05:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763471AbXFEJuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 05:50:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57898 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763276AbXFEJub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 05:50:31 -0400
Date: Tue, 5 Jun 2007 11:50:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc3-mm1
Message-ID: <20070605095025.GA29029@elte.hu>
References: <20070530235823.793f00d9.akpm@linux-foundation.org> <20070605091151.GA18385@elte.hu> <20070605022411.f303d28b.akpm@linux-foundation.org> <20070605093349.GA24956@elte.hu> <20070605093958.GA26135@elte.hu> <20070605094246.GA27135@elte.hu> <20070605094555.GA28097@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605094555.GA28097@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > commenting out check_nmi_watchdog() produces a booting kernel too. So 
> > it's a side-effect of check_nmi_watchdog(). Problem is, nothing in 
> > nmi.c changed in -mm1 AFAICS.
> 
> ah, plain -rc3 hangs too. So it's one of these commits i guess:
> 
> commit 1eeb66a1bb973534dc3d064920a5ca683823372e
> commit 09198e68501a7e34737cd9264d266f42429abcdc
> commit bbba11c35baaad3f70f32e185a2c1d40d7901fe9
> commit bf8696ed6dfa561198b4736deaf11ab68dcc4845

oh, damn. The resulting kernel after having undone these doesnt even 
build ...

	Ingo
