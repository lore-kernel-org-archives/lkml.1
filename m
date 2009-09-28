Return-Path: <linux-kernel-owner+w=401wt.eu-S1753235AbZI1VC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbZI1VC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 17:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbZI1VCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 17:02:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33194 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbZI1VCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 17:02:55 -0400
Date: Mon, 28 Sep 2009 23:02:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Joseph Cihula <joseph.cihula@intel.com>,
       Shane Wang <shane.wang@intel.com>
Subject: Re: [GIT PULL] x86/txt for v2.6.32
Message-ID: <20090928210252.GD1960@elf.ucw.cz>
References: <200909142051.n8EKpiOM017912@terminus.zytor.com> <20090926095631.GH1331@ucw.cz> <200909262344.21257.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909262344.21257.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-09-26 23:44:21, Rafael J. Wysocki wrote:
> On Saturday 26 September 2009, Pavel Machek wrote:
> > Hi!
> > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-txt-for-linus
> > > 
> > > Arnaldo Carvalho de Melo (1):
> > >       x86, intel_txt: Fix typos in Kconfig help
> > > 
> > > H. Peter Anvin (3):
> > >       x86, intel_txt: Factor out the code for S3 setup
> > >       x86, intel_txt: Handle ACPI_SLEEP without X86_TRAMPOLINE
> > 
> > This went in despite my NAK/request for more info. It seems you are
> > simply ignoring feedback you don't like :-(
> 
> The "x86, intel_txt: Handle ACPI_SLEEP without X86_TRAMPOLINE" commit looks
> entirely correct to me.
> 
> I have no comments on "x86, intel_txt: Factor out the code for S3 setup" as
> well, maybe except that the BUG() in tboot_setup_sleep() in the
> !CONFIG_ACPI_SLEEP case is a bit unfortunate.

Well, I worry that S3 support for TXT makes TXT completely useless. A
little liquid nitrogen, remove RAM, place it in another machine,
modify it in any way you want, more liquid nitrogen, place it back.

Oops, protection provided by TXT is lost.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
