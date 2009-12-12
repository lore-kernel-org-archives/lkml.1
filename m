Return-Path: <linux-kernel-owner+w=401wt.eu-S932193AbZLMCPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193AbZLMCPM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 21:15:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbZLMCPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 21:15:11 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39153 "HELO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756722AbZLMCPK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 21:15:10 -0500
Date: Sat, 12 Dec 2009 18:53:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>
Cc: Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Iliyan Malchev <malchev@google.com>, linux-kernel@codeaurora.org
Subject: Re: tree with htc dream support
Message-ID: <20091212175327.GA5819@elf.ucw.cz>
References: <20091205221100.GA32522@elf.ucw.cz>
 <1260054737.23633.35.camel@desktop>
 <a55d774e0912051638u7858878cg7cf62905c3c005c1@mail.gmail.com>
 <d6200be20912112142r7bdf8f18o31edd4457aa64998@mail.gmail.com>
 <20091212112536.GA2302@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091212112536.GA2302@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-12-12 12:25:36, Pavel Machek wrote:
> On Fri 2009-12-11 21:42:07, Arve Hj?nnev?g wrote:
> > On Sat, Dec 5, 2009 at 4:38 PM, Brian Swetland <swetland@google.com> wrote:
> > > Arve's about to take our common and msm trees and rebase them over the .32,
> > > which may be useful for reference -- at least as a snapshot of a fully
> > > functional set of patches that android donut and eclair run on, on
> > > production hardware.  We'll make that available as soon as we have something
> > > that's bootable.
> > >
> > > Brian
> > >
> > >
> > 
> > A first pass of this is available in the android-msm-2.6.32-test1
> > branch at git://android.git.kernel.org/kernel/experimental.git.
> 
> According to some docs, i2c_detach can be just removed, so...?
> 
> Then I got this:

And then I got it to boot. Good! (And a bit after that, probably
watchdog kicked and phone rebooted back into .27.)

On the second try -- with ramdisk.img -- I got it to boot to GUI, but
the GUI did not show up. I can hear the background sounds but not see
anything. I probably need to turn off
CONFIG_FRAMEBUFFER_CONSOLE... Yes, now it boots to the GUI and I can
actually see that. (It would be nice to make GUI work with
FRAMEBUFFER_CONSOLE on; it should not be that hard...).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
