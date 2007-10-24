Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbXJXIev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbXJXIev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 04:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbXJXIeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 04:34:44 -0400
Received: from smtp-103-wednesday.nerim.net ([62.4.16.103]:55980 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752384AbXJXIem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 04:34:42 -0400
Date: Wed, 24 Oct 2007 10:34:39 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Bart Van Assche" <bart.vanassche@gmail.com>, linux-kernel@vger.kernel.org,
       i2c@lm-sensors.org
Subject: Re: [PATCH] I2C: add support for the PCF8575 chip
Message-ID: <20071024103439.22114920@hyperion.delvare>
In-Reply-To: <20071023091845.bcb19caf.akpm@linux-foundation.org>
References: <e2e108260710050232s1b0a9cb7u604ab7e20b61646e@mail.gmail.com>
	<20071022145814.84e46287.akpm@linux-foundation.org>
	<20071023135030.750e9fa4@hyperion.delvare>
	<20071023091845.bcb19caf.akpm@linux-foundation.org>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Tue, 23 Oct 2007 09:18:45 -0700, Andrew Morton wrote:
> On Tue, 23 Oct 2007 13:50:30 +0200 Jean Delvare <khali@linux-fr.org> wrote:
> > You're unfair. I can use the same argument the other way around: if
> > Bart did not post to the wrong list in the first place, then there
> > would have been no risk for you to miss any update.
> 
> Sure.  But what I was referring to was the recommendation that submitters
> explicitly _remove_ lkml from the cc.

Again you are unfair. I never suggested that people _remove_ LKML from
the Cc. I asked that they do not include it to start with, which is
different.

That being said, chances are higher that a list gets dropped in the
course of the discussions if many lists were included in the first
place. Which is just one more reason to not flood too many lists in the
first place.

> (...)
> But I'm not just talking about me.  Consider the example of a random lkml
> lurker who has a PCF8575 and who can end up using an old version of the
> code.

Anyone picking a random patch on any mailing list instead of waiting
for it to go upstream or at least in some developer tree, should be
aware that he/she is running experimental code, and should search for
possible updates. This includes google, marc.info and getting in touch
with the author of the patch if the patch is getting old. If nothing
else, letting the author know that you tested his/her patch is the bare
minimum you can do as a tester if you care about the patch going
upstream.

This really doesn't have anything to do with what list(s) the patch has
been sent to in the first place.

> > Still... I am worried that you, Andrew Morton, co-top-maintainer of the
> > Linux 2.6 kernel, one of most brilliant kernel developers we have,
> > waste your time doing the initial review of a random i2c patch that
> > about anyone remotely involved in kernel development would have been
> > able to review. There's something wrong here.
> 
> It goes like this:
> 
> - patch floats past, I save it
> 
> - a week or three later I check to see if it is still unmerged
> 
> - if so, go look at the lkml thread
> 
> - if nothing much has happened then I'll assume that it got lost and will
>   pick it up so that it gets consideration
> 
> If the discussion got steered to a different list and lkml got removed from
> that discussion then I end up wasting everyone's time.

That's unfortunate, but I'd guess this happens all the time and this is
inherently bound to the way you work. Picking random patches after 3
weeks and assuming that nothing happened to them just because LKML says
so, is quite a risky bet, methinks.

My opinion on the matter is that it's up to submitters to make sure
that non-bugfix patches they send aren't lost, not maintainers. If
someone sends a patch adding support for a new device, and nobody
replies, I say it's up to the sender to resend the patch, or even
better to actively look for someone to review the patch, instead of
passively waiting for something to happen. The kernel is growing fast,
and the only way for us maintainers to scale is to teach contributors
how to help us keep up with the workload.

Bugfix patches are of course different, it's up to the maintainers to
review them quickly and make sure they aren't lost, no question about
that.

You have a different opinion, you insist on picking _all_ patches and
taking care of everything. This is your own right, you are free to work
the way you want and I respect that. But please don't expect me to
change the way _I_ want to work to accommodate the way _you_ want work.

-- 
Jean Delvare
