Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbXHaWH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbXHaWH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 18:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846AbXHaWHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 18:07:46 -0400
Received: from [81.2.110.250] ([81.2.110.250]:38140 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750762AbXHaWHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 18:07:45 -0400
Date: Fri, 31 Aug 2007 23:16:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-serial@vger.kernel.org
Subject: Re: Heads Up: Next Batch Of Serial/TTY Changes
Message-ID: <20070831231613.6b0fcdfd@the-village.bc.nu>
In-Reply-To: <20070831.144115.48807246.davem@davemloft.net>
References: <20070831221105.2fce9023@the-village.bc.nu>
	<20070831.144115.48807246.davem@davemloft.net>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Aug 2007 14:41:15 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Date: Fri, 31 Aug 2007 22:11:05 +0100
> 
> > Firstly some architecture maintainers still haven't updated their
> > platform for arbitary tty speeds. The kernel is going to start whining
> > and issuing warnings on your platform if you don't keep up with the
> > programme (its been 6 months).
> 
> I took a look at this for sparc and I'm currently balking the same way
> you did :-) The current bit usage on sparc just don't work properly
> for what you're trying to do.

I don't see a real problem. You aren't using

	c_cflags & CBAUD = 0x00001000

so that could become BOTHER.

the input bits also appear to be reserved and free ?

