Return-Path: <linux-kernel-owner+w=401wt.eu-S1762101AbXGFDkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762101AbXGFDkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 23:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758263AbXGFDkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 23:40:43 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:26577 "EHLO
	asav17.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526AbXGFDkn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 23:40:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswMAKhWjUZKhRO4R2dsb2JhbACPJQEBGw0GEQE
From: Dmitry Torokhov <dtor@insightbb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull][resend] Input updates for 2.6.22-rc7
Date: Thu, 5 Jul 2007 23:40:41 -0400
User-Agent: KMail/1.9.3
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200707050111.43327.dtor@insightbb.com> <alpine.LFD.0.98.0707051556000.9434@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0707051556000.9434@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707052340.42226.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 July 2007 19:09, Linus Torvalds wrote:
> 
> On Thu, 5 Jul 2007, Dmitry Torokhov wrote:
> > 
> > Please consider pulling from:
> > 
> >         git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
> 
> There's somethign wrong with your emails, and it's very irritating.
> 

Oops, sorry.

> I cannot just cut-and-paste the whole line, because your tabs and spaces 
> aren't tabs and spaces, they are some horrible abomination.
> 

Yes, for some reason Kmail somethmes does this when cut-and-pasting
from another email. I don't think it does it when cutting and pasting
from anywhere else...

> What _looks_ like a tab above, when I save it and look at it with "od", it 
> shows it true nasty life: it's not a tab, and it's not even eight spaces, 
> it's four copies of the byte sequence '\302\240 ' ('\xC2\xA0\x20'), ie 
> some horrid nasty three-byte sequence where one character is a space, and 
> the previous two characters are some utf-8 abomination.
> 
> I have no idea what kind of crap you use to generate it, and quite 
> frankly, I don't want to know. I just want it to stop, so that when I 
> cut-and-paste, I don't get random UTF-8 characters that just *look* like 
> spaces but don't act like it, and cause my shell to very reasonably whine 
> about the result.
> 
> I think the "c2 a0" character is the utf-8 representation of a &nbsp 
> (non-breaking space), but:
>  - you are damn well sending text
>  - it's followed by a regular space, so it's stupid
>  - please don't do it.
> 
> It says your user-agent is "Kmail", and maybe there is some way to fix it. 
> And if kmail is correct, please make a bug-report to the kmail people. 
> Sending hidden invisible utf-8 crap that looks like space, but doesn't act 
> like it, is just damn impolite by kmail. I assume you weren't even aware 
> of the random crud you are sending out?
>

I was not... The copy I got from LKML looks fine in Kmail, Gmail and
MS Outlook.

The thing is I like Kmail because it never screwed up patches that I sent
out. I guess I will just stop cutting and pasting e-mails and just adjust
my script that generates changelog and diffstat. The issue may even be
already fixed in newer versions of Kmail, I am a little behind times with
my setup...

-- 
Dmitry
