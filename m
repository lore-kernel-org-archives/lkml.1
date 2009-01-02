Return-Path: <linux-kernel-owner+w=401wt.eu-S1758364AbZABQYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364AbZABQYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 11:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757035AbZABQYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 11:24:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40542 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbZABQYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 11:24:04 -0500
Date: Fri, 2 Jan 2009 17:23:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Valdis.Kletnieks@vt.edu
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Bryan Donlan <bdonlan@gmail.com>, Ingo Brueckl <ib@wupperonline.de>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86 (Linux Tiny): configure out support for some processors
Message-ID: <20090102162357.GH1180@elte.hu>
References: <495d2974@wupperonline.de> <3e8340490901012119i40971452q9f938702e58d7532@mail.gmail.com> <3f9a31f40901012159l255b95a8he41a341f36ebc54e@mail.gmail.com> <20090102093801.GD1975@elte.hu> <3f9a31f40901020710h508bbfbch3d7ccd6f4898ea03@mail.gmail.com> <11444.1230910752@turing-police.cc.vt.edu> <3f9a31f40901020813t136ad2ceif1092f312866a0ce@mail.gmail.com> <13903.1230913212@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13903.1230913212@turing-police.cc.vt.edu>
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


* Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:

> On Fri, 02 Jan 2009 21:43:03 +0530, Jaswinder Singh Rajput said:
> 
> > Let me know why should I choose EMBEDDED option ? I know I am not 
> > using Embbeded machine and I do not need embbeded features on my 
> > machine. If I am willing to go North why should I go South first ?
> 
> EMBEDDED is a bad name for the option.  It *started* as "only those 
> maniac who need to trim their kernel WAY down should select this", and 
> ended up as "stuff that 95% of users shouldn't change, but you can if 
> you know what you're doing".

i think both activities fit the generic 'embedded/specialized kernel' term 
quite well, so i dont think there's a big naming problem. There's maybe a 
documentation problem - the help text could be improved some more to 
signal that certain specialized config options are only available under 
CONFIG_EMBEDDED.

	Ingo
