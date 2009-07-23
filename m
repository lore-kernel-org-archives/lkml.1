Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbZGWVZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbZGWVZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 17:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbZGWVZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 17:25:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47526 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbZGWVZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 17:25:14 -0400
Date: Thu, 23 Jul 2009 23:25:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>
Cc: Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: HTC: touchscreen driver
Message-ID: <20090723212506.GS28158@elf.ucw.cz>
References: <20090713220726.GA28375@elf.ucw.cz> <d6200be20907131829o77bce3d8w8f238bc079478368@mail.gmail.com> <20090714094629.GB2076@elf.ucw.cz> <d6200be20907141507s39b54cccq9f0cedc325d3a203@mail.gmail.com> <20090714221638.GA6512@elf.ucw.cz> <d6200be20907141545k2b40b790x1af853b89517891c@mail.gmail.com> <20090719212330.GI26511@elf.ucw.cz> <d6200be20907192043w3f1aa2abvd0125163e6f5519c@mail.gmail.com> <20090721101103.GD4133@elf.ucw.cz> <d6200be20907211812l47012c00i1fc7de53db97d702@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d6200be20907211812l47012c00i1fc7de53db97d702@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-07-21 18:12:03, Arve Hj?nnev?g wrote:
> On Tue, Jul 21, 2009 at 3:11 AM, Pavel Machek<pavel@ucw.cz> wrote:
> > On Sun 2009-07-19 20:43:10, Arve Hj?nnev?g wrote:
> >> On Sun, Jul 19, 2009 at 2:23 PM, Pavel Machek<pavel@ucw.cz> wrote:
> >> >
> >> >> > Applying small patch on top of cleaned up driver should be better than
> >> >> > carrying whole driver itself, right?
> >> >>
> >> >> Perhaps, but the only problem I encountered with this driver so far
> >> >> was when calling disable_irq from the interrupt handler stopped
> >> >> working on non-smp systems in 2.6.30 (which is another patch you
> >> >> should probably apply first).
> >> >
> >> > How do I get that patch? git pull on msm-2.6.29 tree?
> >>
> >> No it is in the android-msm-2.6.30-rc2-test branch at
> >> git://android.git.kernel.org/kernel/experimental.git (commit
> >> 9f89902daf7a3c6fdd6b0c7494f3cc82d5e09217).
> >
> > Could you inline the patch? I tried to pull it off the web interface,
> > but it did not work for some reason.
> 
> git fetch git://android.git.kernel.org/kernel/experimental.git
> android-msm-2.6.30-rc2-test
> git cherry-pick 9f89902daf7a3c6fdd6b0c7494f3cc82d5e09217

So I spent 10 minutes downloading patch you could have inlined... only
to find out that review already pointed nosync issue (and I fixed swap
independetly)...

> That way you will hopefully not add question marks to my name.

...and I still don't know what your name is. My terminal displays "Arve
Hj#¸nnev##g <arve@android.com>" :-(.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
