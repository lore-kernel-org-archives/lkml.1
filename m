Return-Path: <linux-kernel-owner+w=401wt.eu-S1753387AbYI3H4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbYI3H4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbYI3H4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:56:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35149 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbYI3H4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:56:05 -0400
Date: Tue, 30 Sep 2008 09:55:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: Typo bug [Re: Linux 2.6.27-rc8]
Message-ID: <20080930075553.GB20241@elte.hu>
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org> <20080930094346.307ef1e5@werewolf.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080930094346.307ef1e5@werewolf.home>
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


* J.A. Magallón <jamagallon@ono.com> wrote:

> Hi....
> 
> On Mon, 29 Sep 2008 15:39:09 -0700 (PDT), Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > 
> > So yet another week, another -rc. This one should be the last one: we're 
> > certainly not running out of regressions, but at the same time, at some 
> > point I just have to pick some point, and on the whole the regressions 
> > don't look _too_ scary. And -rc8 obviously does fix more of them.
> > 
> > Most of the changes since -rc7 are pretty small, and there aren't even a 
> > whole lot of them. The shortlog (appended) is just a couple of pages, and 
> > the diffstat is even smaller, but since the dirstat is a dense overview, 
> > I'll just put that here instead:
> > 
> 
> 
> Dealing with my Aspire One setup, I found this (so obvious I don't 
> send a patch:)
> 
> 
> arch/x86/kernel/cpu/mtrr/main.c:
> 
> static int __init disable_mtrr_cleanup_setup(char *str)
> {
>     if (enable_mtrr_cleanup != -1)
>         enable_mtrr_cleanup = 0;
>     return 0;
> }
> early_param("disable_mtrr_cleanup", disable_mtrr_cleanup_setup);
> 
> static int __init enable_mtrr_cleanup_setup(char *str)
> {
>     if (enable_mtrr_cleanup != -1)
>         enable_mtrr_cleanup = 1;
>     return 0;
> }
> early_param("enble_mtrr_cleanup", enable_mtrr_cleanup_setup);
>              ^^^^^^
> 
> Nice ;)

heh. Could you send a patch with a changelog please?

	Ingo
