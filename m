Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbYKTNSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbYKTNSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 08:18:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbYKTNRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 08:17:55 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46050 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754413AbYKTNRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 08:17:55 -0500
Date: Thu, 20 Nov 2008 13:17:26 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thomas Pfaff <tpfaff@pcs.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question about TTY_DO_WRITE_WAKEUP
Message-ID: <20081120131726.2636b559@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0811201007120.30713@lxtpfaff.pcs.ditec.de>
References: <Pine.LNX.4.64.0811201007120.30713@lxtpfaff.pcs.ditec.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2008 11:06:19 +0100 (CET)
Thomas Pfaff <tpfaff@pcs.com> wrote:

> I have written a program that reads and writes data to the serial uart using 
> async io.
> Unfortunately it does not work properly because a SIGIO is never gerated when 
> output becomes possible, the reason is that TTY_DO_WRITE_WAKEUP is not set for 
> most of the tty drivers. After i set the bit in serial_core.c the program works 
> as expected.
> Now i wonder why TTY_DO_WRITE_WAKEUP is almost always disabled ?

Almost nobody uses SIGIO based I/O, especially on serial so I'm not
actually suprised by this one. If you've got patches that fix it then
please send them in.

Alan
