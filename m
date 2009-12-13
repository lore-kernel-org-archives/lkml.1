Return-Path: <linux-kernel-owner+w=401wt.eu-S1754352AbZLMV30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbZLMV30 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 16:29:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbZLMV3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 16:29:25 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46906 "HELO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754317AbZLMV3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 16:29:25 -0500
Date: Sun, 13 Dec 2009 22:29:18 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Arve Hj?nnev?g <arve@android.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Iliyan Malchev <malchev@google.com>
Subject: Re: GPIO support for HTC Dream
Message-ID: <20091213212918.GE5114@elf.ucw.cz>
References: <20091208102842.GH12264@elf.ucw.cz>
 <20091208224550.GA26915@n2100.arm.linux.org.uk>
 <d6200be20912081639mdd853bg4080f415116d018c@mail.gmail.com>
 <20091209113739.GC22752@elf.ucw.cz>
 <1260375495.23633.175.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260375495.23633.175.camel@desktop>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-12-09 08:18:15, Daniel Walker wrote:
> On Wed, 2009-12-09 at 12:37 +0100, Pavel Machek wrote:
> > On Tue 2009-12-08 16:39:09, Arve Hj?nnev?g wrote:
> > > On Tue, Dec 8, 2009 at 2:45 PM, Russell King - ARM Linux
> > > <linux@arm.linux.org.uk> wrote:
> > > > On Tue, Dec 08, 2009 at 11:28:43AM +0100, Pavel Machek wrote:
> > > >> Add GPIO support for HTC Dream.
> > > >>
> > > >> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > > >>
> > > >> diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
> > > >> index f780086..774c50e 100644
> > > >> --- a/arch/arm/mach-msm/Kconfig
> > > >> +++ b/arch/arm/mach-msm/Kconfig
> > > >> @@ -40,4 +40,8 @@ config MACH_TROUT
> > > >>       help
> > > >>         Support for the HTC Dream, T-Mobile G1, Android ADP1 devices.
> > > >>
> > > >> +config GENERIC_GPIO
> > > >> +     bool
> > > >> +     default y
> > > >
> > > > Please arrange for this to be handled just like every other ARM
> > > > platform via a 'select' statement - eg:
> > > >
> > > > config ARCH_AT91
> > > >        bool "Atmel AT91"
> > > >        select GENERIC_GPIO
> > > >        select ARCH_REQUIRE_GPIOLIB
> > > >        select HAVE_CLK
> > > >
> > > > It is not nice to have multiple definitions of the same symbol scattered
> > > > throughout the Kconfig files.
> > > >
> > > 
> > > Why did this code get pulled into the dream gpio code? The original
> > > change that adds msm gpio support already selects GENERIC_GPIO
> > > (http://android.git.kernel.org/?p=kernel/msm.git;a=commit;h=5ae9f4403530a5782478c35d29753081750c4188).
> > > Since you copied half of the files from that change anyway, it would
> > > be better to just include that change in you patch set.
> > 
> > I'm not sure how to do that with git without pulling all the changes
> > before that one, too :-(.
> 
> I'm going to end up pulling a lot of these git commit into my git tree.
> It would be pretty easy for me to just pull this GPIO change directly ..
> I assume you haven't found a way to work with git that suites you? It
> would be best if you used git, but I could try to do some sort of quilt
> export if that works better for you.

I can easily "pull" git trees. I do my own work in git, but usually
not in a way that would be useful for pushing upstream (see my trees
at git.kernel.org). 

I *could* add my dream trees to those that are mirrored at kernel.org,
when things settle a bit. (Should I?)

But I'd really prefer to push my stuff using plain old patches in
emails.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
