Return-Path: <linux-kernel-owner+w=401wt.eu-S1752986AbYIMQpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbYIMQpZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 12:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbYIMQpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 12:45:15 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4094 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751863AbYIMQpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 12:45:13 -0400
Date: Sat, 13 Sep 2008 18:24:10 +0200
From: Pavel Machek <pavel@suse.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       dwmw2@infradead.org, drepper@redhat.com, mingo@elte.hu, tglx@tglx.de
Subject: Re: [PATCH 12/13] hrtimer: create a "timer_slack" field in the task struct
Message-ID: <20080913162409.GC6827@ucw.cz>
References: <20080901160343.75a89ec9@infradead.org> <20080901161423.59ebf2fc@infradead.org> <20080902100439.GA11383@elf.ucw.cz> <20080902060323.70245b83@infradead.org> <20080908132713.GA18486@elf.ucw.cz> <20080908064002.7abc2a22@infradead.org> <20080908141555.GB31784@elf.ucw.cz> <20080908072220.75fc3dfd@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080908072220.75fc3dfd@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Yes, it is a great advantage, but it feels like a hack. Maybe it is
> > better done with LD_PRELOAD or something?
> 
> that's not working very well in general, and doesn't work across exec
> etc.

LD_PRELOAD should work over exec...

Another possibility would be to declare new syscalls, and have glibc
automatically use select_slack(, foo) if GLIBC_SLACK=foo.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
