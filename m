Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbZLIQSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbZLIQSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 11:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756171AbZLIQSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 11:18:49 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36389 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163AbZLIQSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 11:18:49 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5826"; a="29469729"
Subject: Re: GPIO support for HTC Dream
From: Daniel Walker <dwalker@codeaurora.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Arve Hj?nnev?g <arve@android.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Iliyan Malchev <malchev@google.com>
In-Reply-To: <20091209113739.GC22752@elf.ucw.cz>
References: <20091208102842.GH12264@elf.ucw.cz>
	 <20091208224550.GA26915@n2100.arm.linux.org.uk>
	 <d6200be20912081639mdd853bg4080f415116d018c@mail.gmail.com>
	 <20091209113739.GC22752@elf.ucw.cz>
Content-Type: text/plain
Date: Wed, 09 Dec 2009 08:18:15 -0800
Message-Id: <1260375495.23633.175.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-09 at 12:37 +0100, Pavel Machek wrote:
> On Tue 2009-12-08 16:39:09, Arve Hj?nnev?g wrote:
> > On Tue, Dec 8, 2009 at 2:45 PM, Russell King - ARM Linux
> > <linux@arm.linux.org.uk> wrote:
> > > On Tue, Dec 08, 2009 at 11:28:43AM +0100, Pavel Machek wrote:
> > >> Add GPIO support for HTC Dream.
> > >>
> > >> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > >>
> > >> diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
> > >> index f780086..774c50e 100644
> > >> --- a/arch/arm/mach-msm/Kconfig
> > >> +++ b/arch/arm/mach-msm/Kconfig
> > >> @@ -40,4 +40,8 @@ config MACH_TROUT
> > >>       help
> > >>         Support for the HTC Dream, T-Mobile G1, Android ADP1 devices.
> > >>
> > >> +config GENERIC_GPIO
> > >> +     bool
> > >> +     default y
> > >
> > > Please arrange for this to be handled just like every other ARM
> > > platform via a 'select' statement - eg:
> > >
> > > config ARCH_AT91
> > >        bool "Atmel AT91"
> > >        select GENERIC_GPIO
> > >        select ARCH_REQUIRE_GPIOLIB
> > >        select HAVE_CLK
> > >
> > > It is not nice to have multiple definitions of the same symbol scattered
> > > throughout the Kconfig files.
> > >
> > 
> > Why did this code get pulled into the dream gpio code? The original
> > change that adds msm gpio support already selects GENERIC_GPIO
> > (http://android.git.kernel.org/?p=kernel/msm.git;a=commit;h=5ae9f4403530a5782478c35d29753081750c4188).
> > Since you copied half of the files from that change anyway, it would
> > be better to just include that change in you patch set.
> 
> I'm not sure how to do that with git without pulling all the changes
> before that one, too :-(.

I'm going to end up pulling a lot of these git commit into my git tree.
It would be pretty easy for me to just pull this GPIO change directly ..
I assume you haven't found a way to work with git that suites you? It
would be best if you used git, but I could try to do some sort of quilt
export if that works better for you.

Daniel

