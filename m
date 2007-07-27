Return-Path: <linux-kernel-owner+w=401wt.eu-S1760285AbXG0Sqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760285AbXG0Sqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 14:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758228AbXG0Sqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 14:46:35 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:49042
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757439AbXG0Sqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 14:46:34 -0400
Subject: Re: serial flow control appears broken
From: Paul Fulghum <paulkf@microgate.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Lee Howard <faxguy@howardsilvan.com>, linux-serial@vger.kernel.org,
       tytso@mit.edu, rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <46AA3801.7090204@shaw.ca>
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no>
	 <46A84B4A.6070902@shaw.ca> <46A8C6F1.4080309@howardsilvan.com>
	 <Pine.LNX.4.64N.0707271216410.425@blysk.ds.pg.gda.pl>
	 <46AA2748.80703@howardsilvan.com>
	 <Pine.LNX.4.64N.0707271825220.425@blysk.ds.pg.gda.pl>
	 <46AA3801.7090204@shaw.ca>
Content-Type: text/plain
Date: Fri, 27 Jul 2007 13:46:06 -0500
Message-Id: <1185561966.23486.1.camel@x2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-27 at 12:22 -0600, Robert Hancock wrote:
> Maciej W. Rozycki wrote:
> >  The TTY line discipline driver could do that based on the amount of 
> > received data present in its buffer.  And it should if asked to (a brief 
> > look at drivers/char/n_tty.c reveals it does; obviously there may be a bug 
> 
> Really, where? In my look through the code I haven't found any mechanism 
> that would result in RTS being lowered based on TTY buffers filling up, 
> at least not in the 8250 case.

serial_core.c:uart_throttle()
serial_core.c:uart_unthrottle()

These are called by N_TTY in response to buffer levels.
 
--
Paul Fulghum
Microgate Systems, Ltd

