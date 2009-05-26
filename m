Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbZEZTDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbZEZTDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 15:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbZEZTDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 15:03:41 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45356 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbZEZTDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 15:03:41 -0400
Date: Tue, 26 May 2009 21:02:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       "Larry H." <research@subreption.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
	allocator
Message-ID: <20090526190249.GA1326@ucw.cz>
References: <20090520183045.GB10547@oblivion.subreption.com> <1242852158.6582.231.camel@laptop> <4A15A69F.3040604@redhat.com> <20090521202628.39625a5d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090521202628.39625a5d@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I could also imagine the suspend-to-disk code skipping
> > PG_sensitive pages when storing data to disk, and
> > replacing it with some magic signature so programs
> > that use special PG_sensitive buffers can know that
> > their crypto key disappeared after a restore.
> 
> Its irrelevant in the simple S2D case. I just patch other bits of the
> suspend image to mail me the new key later. The right answer is crypted
> swap combined with a hard disk password and thus a crypted and locked
> suspend image. Playing the "I must not miss any page which might be

uswsusp does have internal encryption, and can use dm_crypt encrypted
swap... So yes, we can do encrypted swap & s2disk today.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
