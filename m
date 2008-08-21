Return-Path: <linux-kernel-owner+w=401wt.eu-S1758628AbYHUKlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628AbYHUKlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 06:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754984AbYHUKk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 06:40:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41701 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754907AbYHUKk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 06:40:56 -0400
Date: Thu, 21 Aug 2008 11:23:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Aristeu Rozanski <aris@ruivo.org>
Cc: Tosoni <jp.tosoni@acksys.fr>,
       "'Laurent Pinchart'" <laurentp@cse-semaphore.com>,
       "'Aristeu Rozanski'" <arozansk@redhat.com>,
       linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] 8250: add support for DTR/DSR hardware flow control
Message-ID: <20080821112309.6519c29f@lxorguk.ukuu.org.uk>
In-Reply-To: <20080820214336.GN17926@cathedrallabs.org>
References: <200808071032.16709.laurentp@cse-semaphore.com>
	<000f01c8f88c$ad29d950$2e01a8c0@acksys.local>
	<20080818162526.1975dace@lxorguk.ukuu.org.uk>
	<20080820214336.GN17926@cathedrallabs.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008 17:43:36 -0400
Aristeu Rozanski <aris@ruivo.org> wrote:

> > > About a RS485 ioctl: could you consider the attached files which are already
> > > in the Linux kernel (in include/asm-cris).
> > > They define a TIOCSERSETRS485 (ioctl.h), and the data structure (rs485.h)
> > > with allows to specify timings. Sounds just like what we want ?
> > 
> > I had a deeper look at this for RS485 and the answer is "sort of". I've
> > reworked the structure to keep it the same size irrespective of 32/64bit
> > systems, and to make stuff flags that can be, plus add some extra u32
> > words in case we need to (.. when we need to ;)) add stuff later.
> > 
> > Comments, thoughts - will this do what people in the RS485 world need ?
> as for DTR/DSR patch, will be used the same approach?

I'm still trying to get a sensible answer on how other Unixes handle it
