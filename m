Return-Path: <linux-kernel-owner+w=401wt.eu-S1752678AbYAPLmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbYAPLmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 06:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbYAPLm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 06:42:27 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59465 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751415AbYAPLm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 06:42:26 -0500
Date: Wed, 16 Jan 2008 12:42:34 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcelo Tosatti <marcelo@kvack.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Daniel Spang <daniel.spang@gmail.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 3/5] add /dev/mem_notify device
Message-ID: <20080116114234.GA22460@elf.ucw.cz>
References: <20080115100029.1178.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080115221627.GC1565@elf.ucw.cz> <20080116105102.11B1.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080116041332.GA30877@dmt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080116041332.GA30877@dmt>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-01-16 02:13:32, Marcelo Tosatti wrote:
> On Wed, Jan 16, 2008 at 10:57:16AM +0900, KOSAKI Motohiro wrote:
> > Hi Pavel
> > 
> > > > 	err = poll(&pollfds, 1, -1); // wake up at low memory
> > > > 
> > > >         ...
> > > > </usage example>
> > > 
> > > Nice, this is really needed for openmoko, zaurus, etc....
> > > 
> > > But this changelog needs to go into Documentation/...
> > > 
> > > ...and /dev/mem_notify is really a bad name. /dev/memory_low?
> > > /dev/oom?
> > 
> > thank you for your kindful advise.
> > 
> > but..
> > 
> > to be honest, my english is very limited.
> > I can't make judgments name is good or not.
> > 
> > Marcelo, What do you think his idea?
> 
> "mem_notify" sounds alright, but I don't really care.
> 
> Notify:
> 
> To give notice to; inform: notified the citizens of the curfew by
> posting signs.

I'd read mem_notify as "tell me when new memory is unplugged" or
something. /dev/oom_notify? Plus, /dev/ names usually do not have "_"
in them.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
