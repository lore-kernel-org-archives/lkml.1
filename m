Return-Path: <linux-kernel-owner+w=401wt.eu-S1753086AbZAIQcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbZAIQcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 11:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbZAIQcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 11:32:39 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:39108 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751531AbZAIQci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 11:32:38 -0500
Date: Fri, 9 Jan 2009 17:32:33 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Hellwig <hch@infradead.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
In-Reply-To: <20090108175338.2abbee16.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0901091726370.13230@vixen.sonytel.be>
References: <E1LKy3v-0003KO-Nx@dylan.lougher.demon.co.uk>
 <20090108165029.GA10951@infradead.org> <20090108175338.2abbee16.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jan 2009, Andrew Morton wrote:
> On Thu, 8 Jan 2009 11:50:29 -0500 Christoph Hellwig <hch@infradead.org> wrote:
> > On Thu, Jan 08, 2009 at 04:48:51PM +0000, Phillip Lougher wrote:
> > > Please consider pulling my linux-next branch
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-linus.git
> > > 
> > > The patches have been posted to LKML and linux-fsdevel over the last
> > > couple of months and have been reviewed and changed as requested.
> > > Diffstat below.
> > > 
> > > Squashfs is a compressed read-only filesystem. It compresses metadata
> > > and data, and uses up to 1 MiB block sizes for greater compression.
> > 
> > That seems pretty fast for something only posted this week and not
> > even in -next.
> 
> I discussed this with Phillip a bit, and it looks like we'll go for a
> 2.6.21 merge.  This gives a couple of months for testing and review in
      ^^
(assuming single digit flips :-) 29 or 31? I hope 29...

> linux-next.
> 
> Of course, this assumes that someone will actually perform that testing
> and review.  Chances are that it'll just sit there, getting nothing more
> than compilation testing.

FWIW, I've been running tests on squashfs during the last few months, on
various platforms (32/64 bit, little/big endian, forgiving/notforgiving
unaligned accesses). I admit not having tested the latest squashfs version on
all of them, as some are partially broken due to the current merge window
churn.

> Apparently I reviewed the code a while back - that grey cell must have
> died.  Does anyone else intend to review the code in that timeframe? 
> If not, we might as well merge it now, if ever..

And I've kept a close eye on all changes in the squashfs git repository since
the last formal review on lkml.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
