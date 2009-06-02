Return-Path: <linux-kernel-owner+w=401wt.eu-S1760132AbZFBJT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132AbZFBJT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 05:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756433AbZFBJTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 05:19:19 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36698 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756325AbZFBJTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 05:19:18 -0400
Date: Tue, 2 Jun 2009 11:19:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: ttyACM0: 2.6.30-rc7 dies on device disconnect, strange echo
	(regressions)
Message-ID: <20090602091912.GD15756@elf.ucw.cz>
References: <20090601101421.GA1914@elf.ucw.cz> <200906011242.06244.oliver@neukum.org> <20090601113151.GB2445@elf.ucw.cz> <200906011434.57083.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906011434.57083.oliver@neukum.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-06-01 14:34:56, Oliver Neukum wrote:
> Am Montag, 1. Juni 2009 13:31:51 schrieb Pavel Machek:
> > Steps to reproduce:
> >
> > minicom /dev/ttyACM0
> >
> > Bug #2: try to interactivelly communicate with the other
> > device. Notice that characters are echoed one character too late. You
> > type "hello", but only "hell" appears. You press "!", "o" appears.
> >
> > Bug #1: while minicom is still connected, pull the USB cable. Machine
> > locks hard.
> 
> I can replicate neither bug with 2.6.30-rc7. Can you replicate it with
> anything but openMOKO?

So AT commands echo properly on USB modem or something? Bad :-(.

I'm afraid I do not have another ACM device near me. I guess going
through cdc-acm.c 's history would be relevant?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
