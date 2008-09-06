Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbYIFUia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbYIFUia (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 16:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYIFUiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 16:38:21 -0400
Received: from www.tglx.de ([62.245.132.106]:51738 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658AbYIFUiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 16:38:21 -0400
Date: Sat, 6 Sep 2008 22:37:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alok Kataria <akataria@vmware.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Dan Hecht <dhecht@vmware.com>,
       Garrett Smith <garrett@vmware.com>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
In-Reply-To: <alpine.LFD.1.10.0809061328400.3117@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0809062233500.3243@apollo.tec.linutronix.de>
References: <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org>  <20080904160036.GA18382@elte.hu>  <alpine.LFD.1.10.0809040920000.3381@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809041021110.3400@nehalem.linux-foundation.org> 
 <20080904190728.59634020@lxorguk.ukuu.org.uk>  <alpine.LFD.1.10.0809041114030.3400@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809041303530.4112@nehalem.linux-foundation.org>  <20080904204305.GA29065@elte.hu> <20080904205236.GA3864@elte.hu> 
 <alpine.LFD.1.10.0809041403450.3117@nehalem.linux-foundation.org>  <20080904213350.GA15678@elte.hu> <1220653095.14401.72.camel@alok-dev1> <alpine.LFD.1.10.0809051522410.3117@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809061803470.3243@apollo.tec.linutronix.de>
 <alpine.LFD.1.10.0809061328400.3117@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Sep 2008, Linus Torvalds wrote:
> 
> On Sat, 6 Sep 2008, Thomas Gleixner wrote:
> > 
> > Adding another check after the second get_cycles() makes it reliable:
> 
> My original patch actually had that, and Ingo added it to the -tip tree 
> too (I think), so that should be the one we're discussing anyway. I just 
> didn't think it would ever trigger in practice, which is why I removed it. 
> Mea culpa.

My bad. Did not test that against -tip, just applied it from mail :)

Just checked. The -tip version still has the expect-- in the for()
which might lead to stupid results depending on the gcc madness level.

Thanks,

	tglx
