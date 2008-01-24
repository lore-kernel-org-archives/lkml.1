Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686AbYAXNg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbYAXNg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 08:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbYAXNgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 08:36:51 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58663 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751591AbYAXNgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 08:36:50 -0500
Date: Thu, 24 Jan 2008 10:00:49 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@openvz.org>, Kirill Korotaev <dev@sw.ru>
Subject: Re: [PATCH] printk deadlocks if called with runqueue lock held
Message-ID: <20080124090048.GB10217@elf.ucw.cz>
References: <Pine.LNX.4.58.0801172000430.32679@gandalf.stny.rr.com> <20080123133149.GA4059@ucw.cz> <Pine.LNX.4.58.0801231335450.9982@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0801231335450.9982@gandalf.stny.rr.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-01-23 13:36:12, Steven Rostedt wrote:
> 
> 
> On Wed, 23 Jan 2008, Pavel Machek wrote:
> >
> > Could try_to_wakeup use trylock, and only avoid wakeup if lock is
> > already held?
> > 							Pavel
> 
> I could imagine a lot of missed wakeups caused by that.

...alternative being suggested is to miss _all_ the wakeups. So
"missing some" seems like better alternative.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
