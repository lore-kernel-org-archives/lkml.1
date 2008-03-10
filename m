Return-Path: <linux-kernel-owner+w=401wt.eu-S1751982AbYCJOXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbYCJOXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 10:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750999AbYCJOXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 10:23:17 -0400
Received: from mail.gmx.net ([213.165.64.20]:41716 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750696AbYCJOXQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 10:23:16 -0400
X-Authenticated: #7313500
X-Provags-ID: V01U2FsdGVkX18DS7Ug2a0Da2p7gu7Yy1P4fGLEeGjelP+O5qwjRQ
	rBO5kZutl+oIy0
From: Jan-Simon =?iso-8859-1?q?M=F6ller?= <dl9pf@gmx.de>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
Date: Mon, 10 Mar 2008 15:23:02 +0100
User-Agent: KMail/1.9.9
Cc: Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, devzero@web.de,
       linux-kernel@vger.kernel.org, rick@vanrein.org
References: <182234194@web.de> <200803101224.07628.dl9pf@gmx.de> <20080310115237.GA29197@elf.ucw.cz>
In-Reply-To: <20080310115237.GA29197@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803101523.03620.dl9pf@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 10 März 2008 12:52:37 schrieb Pavel Machek:
> On Mon 2008-03-10 12:24:06, Jan-Simon Möller wrote:
> > Am Montag 10 März 2008 11:14:48 schrieben Sie:
> > > Feel free to improve memmap documentation.
> >
> > BUT ...
> > to do that, I would need to know already a bit of memmap ?!
> >
> > This is a Chicken-egg-problem !
> >
> > And I won't "waste" my time if i've a solution at hand already ?!
>
> ...so you waste everyone elses...?

This is no fair answer, Pavel - I already invested my time to find a solution 
and only found BadRAM at that time. So my impression is that for memmap 
there's so little doc that no average user is able to use it. This will also 
prevent users from making "derived" documentation for other use-cases. And 
again we're back to the chicken-egg ??
You can have the "nicest" solution out there - as long as its 
either "nasty-to-use" or zero-documented, no one will really use it.

> > Lets do it like this: Show me what i need to know about the usage of
> > memmap and i'll write some doc.
> >
> > Just shouting "write your own doc" is pointless, as I don't know this
> > part of the kernel myself (yet).
>
> Read the thread you are replying to. It was already there.

I did that and also read kernel-parameters.txt / memory.txt :
But there is _NO_ example line, just the synopsis. 
Do you expect all users to know what's e820 table is ? - this is not 
realistic. Not everybody is an expert in computer science.

Thats why BadRAM is used out there - memtest prints the values and BadRam can 
use them.

Lets try to get an example and document it:
My starting point would be: i wanna exclude this memory-area

badram=0x18690000,0xffff0000
(which means a whole from 0x18690000 to 0x1869ffff )

what would that be in memmap= -Syntax if i've got 2GB RAM in total ?

Best regards
Jan-Simon
