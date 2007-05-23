Return-Path: <linux-kernel-owner+w=401wt.eu-S1763423AbXEWTas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763423AbXEWTas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 15:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756164AbXEWTal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 15:30:41 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48236 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755873AbXEWTak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 15:30:40 -0400
Date: Wed, 23 May 2007 20:34:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rene Herman <rene.herman@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] CDROM: replace jiffies busyloop with msleep
Message-ID: <20070523203436.01a005b0@the-village.bc.nu>
In-Reply-To: <46548ADB.60207@gmail.com>
References: <1179829525.12708.118.camel@chaos>
	<46548ADB.60207@gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> driver was snappy in that regard. When I replaced our sleeping loop with a 
> busy-wait same as the original the snappyness returned and moreover, reading 
> the TOC from the CD went from something close to a minute to approximately a 
> second. Thought that minute was just because I was dealing with an old junk 
> 1-speed drive...

It happens. If you want to be fairer you can check need_resched in the
loop so that you still share the CPU fairly with other users.

