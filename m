Return-Path: <linux-kernel-owner+w=401wt.eu-S932215AbZHUN2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215AbZHUN2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 09:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755371AbZHUN2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 09:28:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52048 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215AbZHUN2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 09:28:11 -0400
Date: Fri, 21 Aug 2009 15:26:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jes Sorensen <jes@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Latest Linus tree oopses on Nehalem box
Message-ID: <20090821132658.GD10263@elte.hu>
References: <4A8E7CBE.3020209@sgi.com> <20090821114645.GD24647@elte.hu> <4A8E9B63.4090400@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8E9B63.4090400@sgi.com>
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


* Jes Sorensen <jes@sgi.com> wrote:

> On 08/21/2009 01:46 PM, Ingo Molnar wrote:
>> Might be useful to see your full crashlog, if you are allowed to
>> post that, plus your kernel .config would be useful to know too.
>> Plus would be useful to know whether this is a regression relative
>> to .30 or a yet unfixed bug triggering on your class of hardware.
>
> Hi again,
>
> It looks like this is either timing related or a false alarm :(
>
> I saved the .config reverted to an older commit, and then tried to 
> go back, and now the thing will suddenly boot.
>
> I'll try to see if I can reproduce it, if I manage, I shall be 
> happy to post the .config and the full boot log. It's a Supermicro 
> motherboard of some sort:
>
> Supermicro X8DTN+
> AMIBIOS Core Ver:08.00.15
>
> There is nothing special about it, but I know the BIOS is utter junk.
>
> Sorry for the noise.

I'd say it's timing related and still unfixed - crashes that deep in 
the scheduler we'd sure know about, had we fixed such in any recent 
kernels. Do you still have the last 10 lines of the bootup leading 
up to the crash?

	Ingo
