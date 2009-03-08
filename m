Return-Path: <linux-kernel-owner+w=401wt.eu-S1751698AbZCHKAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbZCHKAU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 06:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZCHKAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 06:00:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42769 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbZCHKAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 06:00:04 -0400
Date: Sun, 8 Mar 2009 10:59:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: "H. Peter Anvin" <hpa@kernel.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: AMD 64 Box is not able to boot with latest -tip
Message-ID: <20090308095952.GA12298@elte.hu>
References: <1236441089.3285.6.camel@localhost.localdomain> <49B31909.9020407@kernel.org> <1236498137.2807.5.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236498137.2807.5.camel@ht.satnam>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> Hello Peter,
> 
> On Sat, 2009-03-07 at 17:02 -0800, H. Peter Anvin wrote:
> > Jaswinder Singh Rajput wrote:
> > > My AMD 64 Box was not able to boot with latest -tip and kernel is
> > > dumping.
> > > 
> > > Because of hot weather and not proper cooling I cannot debug the problem
> > > so only thing I can tell is:
> > > 
> > > BAD : cb553adb4e83bc
> > > 
> > > Good : f0ef03985130287c6c
> > > 
> > 
> > You realize you left absolutely no usable information in that post, I
> > hope... not a single bit of detail about the system other than it having
> > an AMD CPU.
> 
> Oops, I have send my configs file and other related info 
> various times to LKML and Ingo.

You should attach such information to every separate new 
bugreport.

> Anyhow now I made a git tree for it ;)
> 
> http://git.kernel.org/?p=linux/kernel/git/jaswinder/kernel-cfgs.git;a=summary

that's not very useful for a quick review on lkml. Also, kernel 
configs change between kernel versions so that link can go 
stale. So it's always useful to attach the very config you saw a 
breakage with to the bugreport.

You say that the "kernel dumps" - does this mean you got a 
kernel oops during bootup? If possible you should try to capture 
the first oops/warning that triggers either via a serial console 
or via a digital camera. pause_on_oops=10000 can be useful too 
to make sure you capture the first oops in its entirety.

	Ingo
