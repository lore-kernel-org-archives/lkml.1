Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbYKDUUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbYKDUUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 15:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbYKDUUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 15:20:25 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58807 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753981AbYKDUUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 15:20:24 -0500
Date: Tue, 4 Nov 2008 21:20:11 +0100
From: Pavel Machek <pavel@suse.cz>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Michael Tokarev <mjt@tls.msk.ru>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: data corruption: revalidating a (removable) hdd/flash on
	re-insert
Message-ID: <20081104202011.GA7135@ucw.cz>
References: <490B2659.9010304@msgid.tls.msk.ru> <ac3eb2510810310910w603d90bai8c23b34fb517f21a@mail.gmail.com> <20081104195728.GC5862@ucw.cz> <ac3eb2510811041213l4a20fa12h3c5beb3c2d317574@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510811041213l4a20fa12h3c5beb3c2d317574@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >> Every access to removable media is guarded by this revalidation check.
> >> If you don't see these events, you should not trust this reader, and
> >> at least never change the media while it is connected.
> >
> > This is rather nasty data-corrupter.
> 
> Sure, it is.
> 
> > Could we at least blacklist
> > broken device, and force revalidation on each close or something like
> > that?
> 
> What's your idea of revalidation if the hardware does not tell you?
> Get an md5 of the disk content? :)

Well... you should not eject media while fs is mounted or blockdev is
open, correct?

So can we simply claim 'media changed' on last close/unmount? Sure,
sometimes media was not changed, but that only hurts performance, not
correctness... ?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
