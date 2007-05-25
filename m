Return-Path: <linux-kernel-owner+w=401wt.eu-S1755188AbXEYEwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbXEYEwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 00:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbXEYEv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 00:51:57 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751463AbXEYEv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 00:51:56 -0400
Date: Thu, 24 May 2007 21:49:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
cc: Pavel Machek <pavel@ucw.cz>, Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
In-Reply-To: <1180067587.3997.136.camel@nigel.suspend2.net>
Message-ID: <alpine.LFD.0.98.0705242147090.26602@woody.linux-foundation.org>
References: <1179870110.16656.2.camel@localhost> 
 <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org> 
 <1180008394.15600.26.camel@localhost>  <alpine.LFD.0.98.0705240854250.26602@woody.linux-foundation.org>
  <20070524200435.GA9604@elf.ucw.cz>  <alpine.LFD.0.98.0705241323361.26602@woody.linux-foundation.org>
  <20070524220017.GC9604@elf.ucw.cz>  <alpine.LFD.0.98.0705241507050.26602@woody.linux-foundation.org>
  <20070524221743.GD9604@elf.ucw.cz>  <alpine.LFD.0.98.0705241550030.26602@woody.linux-foundation.org>
  <20070524231852.GG9604@elf.ucw.cz>  <alpine.LFD.0.98.0705241736120.26602@woody.linux-foundation.org>
  <1180058123.3997.91.camel@nigel.suspend2.net> 
 <alpine.LFD.0.98.0705241905490.26602@woody.linux-foundation.org> 
 <1180059605.3997.100.camel@nigel.suspend2.net> 
 <alpine.LFD.0.98.0705241931240.26602@woody.linux-foundation.org> 
 <1180062040.3997.112.camel@nigel.suspend2.net> 
 <alpine.LFD.0.98.0705242021560.26602@woody.linux-foundation.org>
 <1180067587.3997.136.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 May 2007, Nigel Cunningham wrote:
> 
> Does that mean you never ever power off your laptop (assuming you have
> one), and the battery never runs out? Surely you must power it off
> completely sometimes?

So? The bootup isn't that much worse than a disk suspend/resume, and it's 
reliable.

And actually, I don't use laptops much. I use mostly desktops, and STR 
works fine on at least some of them. In contrast, doing some 
suspend-to-disk thing would just be insane and idiotic. If I have to wait 
for half a minute and have a slow system even after that because my git 
trees aren't in the cache, I really might as well just shut them off.

In contrast, STR means they are quiet and don't waste energy when I don't 
use them, but they're instantly available when I care. HUGE difference.

I really think suspend-to-disk is just a total waste of my time.

		Linus
