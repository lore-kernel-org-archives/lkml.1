Return-Path: <linux-kernel-owner+w=401wt.eu-S1760794AbXGEXJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760794AbXGEXJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760981AbXGEXJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:09:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39153 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760775AbXGEXJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:09:18 -0400
Date: Thu, 5 Jul 2007 16:09:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Torokhov <dtor@insightbb.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull][resend] Input updates for 2.6.22-rc7
In-Reply-To: <200707050111.43327.dtor@insightbb.com>
Message-ID: <alpine.LFD.0.98.0707051556000.9434@woody.linux-foundation.org>
References: <200707050111.43327.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[ Ok, pulled. However, it's time for another installment of "Flame that 
  stupid mail client", because this isn't the first time this bit me ]

On Thu, 5 Jul 2007, Dmitry Torokhov wrote:
> 
> Please consider pulling from:
> 
>         git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus

There's somethign wrong with your emails, and it's very irritating.

I cannot just cut-and-paste the whole line, because your tabs and spaces 
aren't tabs and spaces, they are some horrible abomination.

What _looks_ like a tab above, when I save it and look at it with "od", it 
shows it true nasty life: it's not a tab, and it's not even eight spaces, 
it's four copies of the byte sequence '\302\240 ' ('\xC2\xA0\x20'), ie 
some horrid nasty three-byte sequence where one character is a space, and 
the previous two characters are some utf-8 abomination.

I have no idea what kind of crap you use to generate it, and quite 
frankly, I don't want to know. I just want it to stop, so that when I 
cut-and-paste, I don't get random UTF-8 characters that just *look* like 
spaces but don't act like it, and cause my shell to very reasonably whine 
about the result.

I think the "c2 a0" character is the utf-8 representation of a &nbsp 
(non-breaking space), but:
 - you are damn well sending text
 - it's followed by a regular space, so it's stupid
 - please don't do it.

It says your user-agent is "Kmail", and maybe there is some way to fix it. 
And if kmail is correct, please make a bug-report to the kmail people. 
Sending hidden invisible utf-8 crap that looks like space, but doesn't act 
like it, is just damn impolite by kmail. I assume you weren't even aware 
of the random crud you are sending out?

		Linus
