Return-Path: <linux-kernel-owner+w=401wt.eu-S934041AbZLOWVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934041AbZLOWVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 17:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934031AbZLOWVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 17:21:11 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56802 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934030AbZLOWVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 17:21:08 -0500
Date: Tue, 15 Dec 2009 23:20:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>
Cc: Daniel Walker <dwalker@codeaurora.org>,
       Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Iliyan Malchev <malchev@google.com>, linux-kernel@codeaurora.org
Subject: Re: tree with htc dream support
Message-ID: <20091215222057.GT24406@elf.ucw.cz>
References: <20091205221100.GA32522@elf.ucw.cz>
 <1260054737.23633.35.camel@desktop>
 <a55d774e0912051638u7858878cg7cf62905c3c005c1@mail.gmail.com>
 <d6200be20912112142r7bdf8f18o31edd4457aa64998@mail.gmail.com>
 <1260627482.20913.7.camel@desktop>
 <d6200be20912121434x1a247837w75c518ba20fe684f@mail.gmail.com>
 <20091213212504.GD5114@elf.ucw.cz>
 <d6200be20912142234ia050c67p34fd2672e7248170@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6200be20912142234ia050c67p34fd2672e7248170@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> >> A first pass of this is available in the android-msm-2.6.32-test1
> >> >> branch at git://android.git.kernel.org/kernel/experimental.git.
> >> >>
> >> >> http://android.git.kernel.org/?p=kernel/experimental.git;a=shortlog;h=refs/heads/android-msm-2.6.32-test1
> >> >
> >> > Does this have the the newest wakelock code in it? From the all the
> >> > re-writes that you've done.
> >>
> >> No.
> >
> > One more wish list item: many drivers are now available in
> > drivers/staging/dream, and are being slowly cleaned up. Would it be
> > possible to start using those for android-msm-2.6.32 tree?
> >
> > You'll need to reapply some stuff I had to remove (like wakelocks),
> > but it should be still better/less work long term to patch those back
> > in than maintaining separate copy. Diff should get much smaller...

> 
> I do plan to look at these, but I don't know when I'll get to it.

Thanks.

Actually... a question. How do I generate diff against mainline from
the tree?

Stuff like 'git diff -r v2.6.11' works, but I need 'git diff -r
v2.6.32', and that fails because tag is just not there :-(. Well, 'git
diff -r 22763c5cf3690a681551162c15d34d935308c8d7' works, but...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
