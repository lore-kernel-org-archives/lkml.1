Return-Path: <linux-kernel-owner+w=401wt.eu-S938961AbZDJPXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938961AbZDJPXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 11:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938884AbZDJPWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 11:22:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S938936AbZDJPWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 11:22:39 -0400
Date: Fri, 10 Apr 2009 08:21:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: MAX3100
In-Reply-To: <20090408114427.28788.50640.stgit@t61.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.0904100808350.4583@localhost.localdomain>
References: <20090408114427.28788.50640.stgit@t61.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Btw, Alan, since you're working on those tty drivers, one thing I thought 
I'd ask you is whether you'd be interested in moving the tty drivers to a 
subdirectory of their own.

>From a quick unscientific count, it looks like of the 271 files in 
drivers/char, about 90 are tty/console-related (done by "git grep -l 
'\<tty\>'"), and the rest are pretty random (either literally about random 
hardware or about agp or just odd stuff).

So I'm wondering if it would make sense to do a drivers/tty for the core 
tty (ldisc, tty_io etc) stuff, and perhaps move some of the non-core 
(serial) drivers into drivers/serial.

I don't know, for example, why drivers/char/stallion.c is not in 
drivers/serial. Just historical reasons, or an actual reason?

Not a big deal, just wondering.

			Linus
