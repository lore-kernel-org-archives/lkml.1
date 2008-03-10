Return-Path: <linux-kernel-owner+w=401wt.eu-S1753222AbYCJKNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbYCJKNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 06:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbYCJKNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 06:13:01 -0400
Received: from mail.gmx.net ([213.165.64.20]:48590 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750967AbYCJKNA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 06:13:00 -0400
X-Authenticated: #7313500
X-Provags-ID: V01U2FsdGVkX1++hz4iEdW+m8rLNPap45687OaI7E1q2kQlv48Ypj
	S47zHQp4ZG4mRR
From: Jan-Simon =?iso-8859-1?q?M=F6ller?= <dl9pf@gmx.de>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
Date: Mon, 10 Mar 2008 11:12:44 +0100
User-Agent: KMail/1.9.9
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       devzero@web.de, pavel@ucw.cz, linux-kernel@vger.kernel.org,
       rick@vanrein.org
References: <182234194@web.de> <47D26A00.7050308@zytor.com> <Pine.LNX.4.64.0803081210540.18589@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0803081210540.18589@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803101112.45105.dl9pf@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 08 März 2008 12:13:01 schrieb Jiri Kosina:
> On Sat, 8 Mar 2008, H. Peter Anvin wrote:
> > > as i said it in another reply to this thread, it would be perfectly
> > > acceptable for upstream to merge an easier to use boot option - be
> > > that badmem=addr$size or excludemem=addr$size. Please send a patch :-)
> >
> > It already called:
> > 	memmap=addr$size
> > ... and has been implemented for years.  Does the badram patch do
> > anything different?  (And yes, I agree the $/@/# is ugly.)
>
> I admit that I haven't examined badram too closely, but I think that what
> it has in addition to what you can get by simple 'memmap=..' is that it
> allows you to use bitmasks to mask particular address patterns.

I had once a bad ram-module and even after heavy search didn't came across 
memmap or its usage. Together with memtest86 badram= is pretty usable.
So for usability's sake i strongly vote for badram=  - good name, quite good 
to use. If you wanna tune on the internal implementation - thats fine ;) .

Best regards
Jan-Simon
