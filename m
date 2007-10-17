Return-Path: <linux-kernel-owner+w=401wt.eu-S1763473AbXJQKkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763473AbXJQKkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 06:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757742AbXJQKka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 06:40:30 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42263 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757190AbXJQKk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 06:40:28 -0400
Date: Wed, 17 Oct 2007 11:43:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty_ioctl: Fix the baud_table check in encode_baud_rate
Message-ID: <20071017114358.3d2b166f@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64N.0710161857280.22596@blysk.ds.pg.gda.pl>
References: <Pine.LNX.4.64N.0710161857280.22596@blysk.ds.pg.gda.pl>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007 19:12:11 +0100 (BST)
"Maciej W. Rozycki" <macro@linux-mips.org> wrote:

>  The tty_termios_encode_baud_rate() function as defined by tty_ioctl.c has 
> a problem with the baud_table within.  The comparison operators are 
> reversed and as a result this table's entries never match and BOTHER is 
> always used.

Oops. I thought I'd fixed that one. Bit bothersome its been in -mm that
long before anyone noticed. 

ACK the first bit.

>  Additionally this function's prototype is not exported unlike the 
> function itself.

That bit seems out of date and a prototype was added later in -mm

