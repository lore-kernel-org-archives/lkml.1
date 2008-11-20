Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbYKTOJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbYKTOJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbYKTOJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:09:47 -0500
Received: from mail.pcs.de ([145.253.69.50]:40440 "EHLO mail.pcs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbYKTOJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:09:46 -0500
Date: Thu, 20 Nov 2008 15:09:43 +0100 (CET)
From: Thomas Pfaff <tpfaff@pcs.com>
X-X-Sender: tpfaff@lxtpfaff.pcs.ditec.de
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: Question about TTY_DO_WRITE_WAKEUP
In-Reply-To: <20081120131726.2636b559@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.64.0811201446380.21561@lxtpfaff.pcs.ditec.de>
References: <Pine.LNX.4.64.0811201007120.30713@lxtpfaff.pcs.ditec.de>
 <20081120131726.2636b559@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 20 Nov 2008 14:09:43.0724 (UTC) FILETIME=[A2F8A6C0:01C94B19]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 20 Nov 2008, Alan Cox wrote:

> On Thu, 20 Nov 2008 11:06:19 +0100 (CET)
> Thomas Pfaff <tpfaff@pcs.com> wrote:
> 
> > I have written a program that reads and writes data to the serial uart using 
> > async io.
> > Unfortunately it does not work properly because a SIGIO is never gerated when 
> > output becomes possible, the reason is that TTY_DO_WRITE_WAKEUP is not set for 
> > most of the tty drivers. After i set the bit in serial_core.c the program works 
> > as expected.
> > Now i wonder why TTY_DO_WRITE_WAKEUP is almost always disabled ?
> 
> Almost nobody uses SIGIO based I/O, especially on serial so I'm not
> actually suprised by this one. If you've got patches that fix it then
> please send them in.

Is the TTY_DO_WRITE_WAKEUP bit some kind of cruft that can be removed entirely 
or should i generate a patch for serial devices only ?

Removing it seems to be cleaner to me but i am unsure if it will break some 
other stuff.
