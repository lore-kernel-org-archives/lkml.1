Return-Path: <linux-kernel-owner+w=401wt.eu-S1754395AbYANRBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbYANRBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 12:01:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYANRA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 12:00:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38740 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbYANRA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 12:00:56 -0500
Date: Mon, 14 Jan 2008 18:00:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matthew <jackdachef@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ed Tomlinson <edt@aei.ca>
Subject: Re: Fwd: Fwd: laptop / computer hardlocks during execution of
	32bit applications(binaries) on 64bit system (Gentoo)
Message-ID: <20080114170036.GL15542@elte.hu>
References: <47841C41.4060401@zytor.com> <e85b9d30801101310p485c7686o30b7cd581043712@mail.gmail.com> <47868B6D.6030208@zytor.com> <e85b9d30801101352hf66826eqe436e61310c96f14@mail.gmail.com> <478694CB.4000306@zytor.com> <e85b9d30801101428s1c760cb1i5ee415738dffb90f@mail.gmail.com> <47869C93.2060308@zytor.com> <e85b9d30801101453k21c60f81v1975cde6a8d5ed52@mail.gmail.com> <20080114161359.GD15542@elte.hu> <e85b9d30801140847k4b19cea4nd08461c1664a1b35@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e85b9d30801140847k4b19cea4nd08461c1664a1b35@mail.gmail.com>
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


* Matthew <jackdachef@gmail.com> wrote:

> > FYI, latest x86.git should have this fix included. So if your box 
> > still hangs there must be some other bug lurking as well.
> 
> 
> the fix from Roland ?: http://lkml.org/lkml/2008/1/11/108
> http://forums.gentoo.org/viewtopic-p-4719206.html#4719206 (+ following posts)
> 
> works like a charm :)
> wine-problems should be solved,
> 
> 64bit firefox & 32bit flash, 32bit firefox, 32bit thunderbird, 
> realplayer work fine again without hardlocking so far (at least for 
> me)

great - thanks for following through with this, this was an important 
regression to get fixed! I've added:

Tested-by: Matthew <jackdachef@gmail.com>

	Ingo
