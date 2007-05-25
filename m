Return-Path: <linux-kernel-owner+w=401wt.eu-S1755867AbXEYCMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbXEYCMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 22:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbXEYCMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 22:12:34 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38278 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752867AbXEYCMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 22:12:33 -0400
Date: Thu, 24 May 2007 19:10:08 -0700 (PDT)
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
In-Reply-To: <1180058123.3997.91.camel@nigel.suspend2.net>
Message-ID: <alpine.LFD.0.98.0705241905490.26602@woody.linux-foundation.org>
References: <1179870110.16656.2.camel@localhost> 
 <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org> 
 <1180008394.15600.26.camel@localhost>  <alpine.LFD.0.98.0705240854250.26602@woody.linux-foundation.org>
  <20070524200435.GA9604@elf.ucw.cz>  <alpine.LFD.0.98.0705241323361.26602@woody.linux-foundation.org>
  <20070524220017.GC9604@elf.ucw.cz>  <alpine.LFD.0.98.0705241507050.26602@woody.linux-foundation.org>
  <20070524221743.GD9604@elf.ucw.cz>  <alpine.LFD.0.98.0705241550030.26602@woody.linux-foundation.org>
  <20070524231852.GG9604@elf.ucw.cz>  <alpine.LFD.0.98.0705241736120.26602@woody.linux-foundation.org>
 <1180058123.3997.91.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 May 2007, Nigel Cunningham wrote:
> 
> First, let me agree with you that for the atomic copy itself, the
> freezer is unnecessary. Disabling irqs and so on is enough to ensure the
> atomic copy is atomic. I don't think any of us are arguing with you
> there.

First off, realize that the problem actually happens during 
suspend-to-ram.

Think about that for a second.

In fact, think about it for a _loong_ time. Because dammit, people seem to 
have a really hard time even realizing this.

	There is no "atomic copy".

	There is no "checkpointing".

	There is no "spoon".

> Hope this helps.

Hope _the_above_ helps. Why is it so hard for people to accept that 
suspend-to-ram shouldn't break because of some IDIOTIC issues with disk 
snapshots?

And why do you people _always_ keep mixing the two up?

			Linus
