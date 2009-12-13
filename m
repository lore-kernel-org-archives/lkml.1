Return-Path: <linux-kernel-owner+w=401wt.eu-S1754347AbZLMVZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbZLMVZS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 16:25:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbZLMVZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 16:25:16 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46611 "HELO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754333AbZLMVZO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 16:25:14 -0500
Date: Sun, 13 Dec 2009 22:25:05 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>
Cc: Daniel Walker <dwalker@codeaurora.org>,
       Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Iliyan Malchev <malchev@google.com>, linux-kernel@codeaurora.org
Subject: Re: tree with htc dream support
Message-ID: <20091213212504.GD5114@elf.ucw.cz>
References: <20091205221100.GA32522@elf.ucw.cz>
 <1260054737.23633.35.camel@desktop>
 <a55d774e0912051638u7858878cg7cf62905c3c005c1@mail.gmail.com>
 <d6200be20912112142r7bdf8f18o31edd4457aa64998@mail.gmail.com>
 <1260627482.20913.7.camel@desktop>
 <d6200be20912121434x1a247837w75c518ba20fe684f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <d6200be20912121434x1a247837w75c518ba20fe684f@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> > Arve's about to take our common and msm trees and rebase them over the .32,
> >> > which may be useful for reference -- at least as a snapshot of a fully
> >> > functional set of patches that android donut and eclair run on, on
> >> > production hardware.  We'll make that available as soon as we have something
> >> > that's bootable.
> >> >
> >> > Brian
> >> >
> >> >
> >>
> >> A first pass of this is available in the android-msm-2.6.32-test1
> >> branch at git://android.git.kernel.org/kernel/experimental.git.
> >>
> >> http://android.git.kernel.org/?p=kernel/experimental.git;a=shortlog;h=refs/heads/android-msm-2.6.32-test1
> >
> > Does this have the the newest wakelock code in it? From the all the
> > re-writes that you've done.
> 
> No.

One more wish list item: many drivers are now available in
drivers/staging/dream, and are being slowly cleaned up. Would it be
possible to start using those for android-msm-2.6.32 tree?

You'll need to reapply some stuff I had to remove (like wakelocks),
but it should be still better/less work long term to patch those back
in than maintaining separate copy. Diff should get much smaller...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
