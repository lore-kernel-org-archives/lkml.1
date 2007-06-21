Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbXFUAUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbXFUAUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 20:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbXFUAUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 20:20:45 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48138 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755140AbXFUAUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 20:20:44 -0400
Date: Thu, 21 Jun 2007 02:20:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, torvalds@linux-foundation.org
Subject: Re: [PATCH] blink: Only blink when parameter is set
Message-ID: <20070621002034.GA18143@elf.ucw.cz>
References: <20070617083904.GC4496@suse.de> <20070620201637.GA5610@ucw.cz> <Pine.LNX.4.64.0706210147260.3068@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706210147260.3068@twin.jikos.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > * It breaks keyboards. Yes, we are talking about maybe-broken i8042s, 
> >   but it still breaks thinkpads at least.
> 
> Hi Pavel,
> 
> this has probably been already solved by proper throttling - see 
> http://lkml.org/lkml/2007/6/15/22

No, it was not. I still saw the problems with CONFIG_BLINK on, that is
one blink per 5 seconds or something.

We should rename CONFIG_BLINK to
CONFIG_BREAK_THINKPAD_KEYBOARD_AND_MORE.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
