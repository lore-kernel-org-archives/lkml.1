Return-Path: <linux-kernel-owner+w=401wt.eu-S1753550AbYIHOOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbYIHOOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 10:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbYIHOOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 10:14:36 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48524 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbYIHOOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 10:14:35 -0400
Date: Mon, 8 Sep 2008 16:15:55 +0200
From: Pavel Machek <pavel@suse.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       dwmw2@infradead.org, drepper@redhat.com, mingo@elte.hu, tglx@tglx.de
Subject: Re: [PATCH 12/13] hrtimer: create a "timer_slack" field in the
	task struct
Message-ID: <20080908141555.GB31784@elf.ucw.cz>
References: <20080901160343.75a89ec9@infradead.org> <20080901161423.59ebf2fc@infradead.org> <20080902100439.GA11383@elf.ucw.cz> <20080902060323.70245b83@infradead.org> <20080908132713.GA18486@elf.ucw.cz> <20080908064002.7abc2a22@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080908064002.7abc2a22@infradead.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-09-08 06:40:02, Arjan van de Ven wrote:
> On Mon, 8 Sep 2008 15:27:16 +0200
> Pavel Machek <pavel@suse.cz> wrote:
> > > 
> > > ... which nobody uses today.
> > > It's not just new syscalls, it's a new glibc api as well at that
> > > point.
> > 
> > ...and new applications, yes. I believe applications should
> > explicitely enable slacking timers.
> 
> timers are slacking today, at least for select() and poll(), and are a
> great deal more so than the defaults in this patchkit.

Ok, so select()/poll() may default to non-zero slack for legacy apps.

> The great advantage of the prctl() approach (which is usable) over new
> system calls and glibc APIs is that it will get used, because the admin
> can use it just like he uses the "nice" command, on existing software.

Yes, it is a great advantage, but it feels like a hack. Maybe it is
better done with LD_PRELOAD or something?

I'd certianly want the applications to specify slack themselves in
like 10 years.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
