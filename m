Return-Path: <linux-kernel-owner+w=401wt.eu-S935568AbYEBQaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935568AbYEBQaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 12:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763736AbYEBQ3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 12:29:50 -0400
Received: from smtp.enter.net ([216.193.128.24]:1964 "EHLO smtp.enter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763730AbYEBQ3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 12:29:50 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: "Parag Warudkar" <parag.warudkar@gmail.com>
Subject: Re: How to reduce the number of open kernel bugs
Date: Fri, 2 May 2008 12:29:46 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Adrian Bunk" <bunk@kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <82e4877d0805020742l7d4a6ec9mc72e79aa3d242348@mail.gmail.com>
In-Reply-To: <82e4877d0805020742l7d4a6ec9mc72e79aa3d242348@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805021229.47038.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 May 2008 10:42:21 Parag Warudkar wrote:
> Adrian Bunk <bunk <at> kernel.org> writes:
> > Maintainer:
> >
> > Yeah, in any case. I cannot fix it, since it's not a bug in the fobar
> > code. Please reopen a new bug and CC the architecture or PCI maintainer
> > or whatever person related to the bus, chipset or CPU, if you think the
> > foobar device still works. If the foobar hardware got corrupted, you
> > already know what to do...
> >
> > I am well aware that loud flames are often the only working way of
> > communication in Linux kernel development, but we mustn't communicate
> > this way with bug submitters.
>
> Actually this way of _communication_ is better because the maintainer has -
>
> a) at least seen the bug
> b) made it clear upfront that he/she is not in a position to fix it and
> c) not inflicted a huge amount of follow up work for the reporter
> while giving no hope that it will be fixed.
>
> There is not much you can do if the maintainer feels he/she can't do
> anything - apart from fixing it yourself which has its limits.
> So the best that can be done is to communicate it clearly - that
> happens in this case.

With the above behavior, someone is reporting "I can use OS's A, B and C with 
no problems - the hardware works perfectly. When I try to use Linux X.Y.Z the 
driver faults and makes things unusable." and the maintainer is saying "The 
driver is fine. I didn't write code that has any bugs in it. The problem is 
your hardware is broken."

That kind of response is irresponsible and idiotic. If the hardware works 
perfectly in every other OS - and possibly even previous versions of Linux - 
then obviously the hardware isn't broken. This is what Adrian was pointing 
out and is exactly what shouldn't be happening.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
