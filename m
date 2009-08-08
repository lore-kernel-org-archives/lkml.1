Return-Path: <linux-kernel-owner+w=401wt.eu-S1752066AbZHHVpC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbZHHVpC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 17:45:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbZHHVpC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 17:45:02 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58043 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbZHHVpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 17:45:00 -0400
Date: Sat, 8 Aug 2009 23:44:54 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: Greg KH <greg@kroah.com>, kernel list <linux-kernel@vger.kernel.org>,
       swetland@google.com, linux-input@vger.kernel.org
Subject: Re: HTC Dream for staging: add support for input on GPIO pins
Message-ID: <20090808214454.GB24153@elf.ucw.cz>
References: <20090808130315.GA12930@elf.ucw.cz> <5d5443650908080942l50d91d31qb23c494affdf6850@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d5443650908080942l50d91d31qb23c494affdf6850@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-08-08 22:12:46, Trilok Soni wrote:
> Hi Pavel,
> 
> On Sat, Aug 8, 2009 at 6:33 PM, Pavel Machek<pavel@ucw.cz> wrote:
> > From: Arve Hj?nnev?g <arve@android.com>
> >
> > Support for input devices connected to GPIO pins. This adds support
> > for HTC Dream's keyboard and its trackball. Generic support already
> > exists for keyboard on GPIO, but this one is more advanced because it
> > can detect shadow key presses (and actually works with Dream :-).
> >
> > (It also contains Kconfig/Makefile changes, including some that were
> > missing from previous commit. Sorry.)
> 
> I don't see any importance of gpio_matrix.c when we already have
> generic gpio matrix driver mainlined. I would suggest to remove those
> bits from this patch. I have added linux-input ML.

Well, I'm trying for staging merge at this point. Reasons why
gpio_matrix is there are:

1) it is non-trivial to remove

2) it has some features mainline lacks

3) HTC Dream actually works with it

(and 4) I'd like to submit code as Arve wrote it, then transform/clean
it up in staging).

Of course, relevant features will need to be extracted from
gpio_matrix and merged at the right places, and that needs to happen
before move from staging/, but I'd like to have working keyboard in
the meantime.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
