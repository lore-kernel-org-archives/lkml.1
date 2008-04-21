Return-Path: <linux-kernel-owner+w=401wt.eu-S1760196AbYDUULy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196AbYDUULy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 16:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbYDUULr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 16:11:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41723 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbYDUULq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 16:11:46 -0400
Date: Mon, 21 Apr 2008 22:11:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Adrian Bunk <bunk@kernel.org>, Alexey Starikovskiy <astarikovskiy@suse.de>,
       tglx@linutronix.de, James.Bottomley@HansenPartnership.com,
       linux-kernel@vger.kernel.org
Subject: Re: Voyager phys_cpu_present_map compile error
Message-ID: <20080421201129.GL8770@elte.hu>
References: <20080421000238.GD26897@cs181133002.pp.htv.fi> <20080421085314.GI26897@cs181133002.pp.htv.fi> <20080421120054.GA6788@elte.hu> <480C8FD6.3030700@zytor.com> <20080421195517.GH8770@elte.hu> <480CF2F9.4060608@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480CF2F9.4060608@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> Ingo Molnar wrote:
>>
>> sure - but no need to be rude and mark it BROKEN when we've got this much 
>> better tool named "email". BROKEN is really just for cases where there's 
>> no-one willing to fix things.
>
> I'm not trying to be rude, I'm just trying to avoid putting an 
> unnecessary burden on testers and just let Kconfig know not to pick 
> this particular random path.  Obviously, Kconfig doesn't care, but 
> it's clear BROKEN has negative associations; besides, it really is 
> unnecessarily strong.
>
> Perhaps what we need is NORAND?

yep, i was thinking about CONFIG_BROKEN2 already :-)

then i came up with: CONFIG_NON_GENERIC. All code that can break a 
normal bootup should be marked with that. Such as CONFIG_ROOT_NFS=y 
[panics on bootup] or CONFIG_EUROTECH_WDT=y [crashes on bootup] or 
CONFIG_SND_MTPAV [hangs on bootup] and the dozens of other config 
options i had to map when trying to bring up an allyesconfig kernel for 
the first time ;-)

auto-tests could then still build-test NON_GENERIC kernels but would not 
attempt to boot them up.

hm?

	Ingo
