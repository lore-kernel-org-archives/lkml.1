Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbZLILcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbZLILcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 06:32:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755090AbZLILcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 06:32:50 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44283 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150AbZLILct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 06:32:49 -0500
Date: Wed, 9 Dec 2009 12:32:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>
Cc: Ryan Mallon <ryan@bluewatersys.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>
Subject: Re: GPIO support for HTC Dream
Message-ID: <20091209113248.GB22752@elf.ucw.cz>
References: <20091208102842.GH12264@elf.ucw.cz>
 <4B1EB57D.6070408@bluewatersys.com>
 <20091208213727.GA4164@elf.ucw.cz>
 <d6200be20912081356i57793417u7bfb2b851fc22521@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6200be20912081356i57793417u7bfb2b851fc22521@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-12-08 13:56:00, Arve Hj?nnev?g wrote:
> On Tue, Dec 8, 2009 at 1:37 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> >> > +#undef MODULE_PARAM_PREFIX
> >> > +#define MODULE_PARAM_PREFIX "board_dream."
> >>
> >> This looks a bit dodgy. Is this
> >> (http://lkml.indiana.edu/hypermail/linux/kernel/0903.0/02768.html) the
> >> preferred way?
> >
> > I don't think that would help that much here....
> 
> That should work, but you have to use board_trout, not board_dream.
> Many of these parameters passed on the kernel command-line by the
> bootloader which uses board_trout. Others are used by userspace which
> also expects to find them under board_trout.

Ok, lets go for board_trout (and a comment). I guess compatibility is
somehow important here.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
