Return-Path: <linux-kernel-owner+w=401wt.eu-S1758256AbZABQVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbZABQVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 11:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756755AbZABQVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 11:21:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43221 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746AbZABQVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 11:21:33 -0500
Date: Fri, 2 Jan 2009 17:21:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Valdis.Kletnieks@vt.edu, Bryan Donlan <bdonlan@gmail.com>,
       Ingo Brueckl <ib@wupperonline.de>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86 (Linux Tiny): configure out support for some processors
Message-ID: <20090102162120.GG1180@elte.hu>
References: <495d2974@wupperonline.de> <3e8340490901012119i40971452q9f938702e58d7532@mail.gmail.com> <3f9a31f40901012159l255b95a8he41a341f36ebc54e@mail.gmail.com> <20090102093801.GD1975@elte.hu> <3f9a31f40901020710h508bbfbch3d7ccd6f4898ea03@mail.gmail.com> <11444.1230910752@turing-police.cc.vt.edu> <3f9a31f40901020813t136ad2ceif1092f312866a0ce@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40901020813t136ad2ceif1092f312866a0ce@mail.gmail.com>
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


* Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:

> On Fri, Jan 2, 2009 at 9:09 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> > On Fri, 02 Jan 2009 20:40:16 +0530, Jaswinder Singh Rajput said:
> >
> >> If I know what is my CPU there is no point for supporting all related
> >> CPUs in my kernel.
> >
> > EMBEDDED is for a large assortment of things, all of which are of the form:
> >
> > General users won't want to change Y, but if I know I don't need Y, there is
> > no point in supporting Y in the kernel.
> >
> 
> On 64 bit AMD machine I was getting :
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   AMD AuthenticAMD
> [    0.000000]   Centaur CentaurHauls
> 
> By using the following patch I get rid of extra CPU support and also 
> reduces size of the kernel.

So you want to save kernel size by making less generic kernels tailored to 
a single box [yours in this case] - basically embedding the kernel on it?

> Let me know why should I choose EMBEDDED option ? I know I am not using 
> Embbeded machine and I do not need embbeded features on my machine. 
> [...]

that is what CONFIG_EMBEDDED=y means in broad terms: "make the kernel more 
specific [more embedded] to a particular hw/sw combination".

	Ingo
