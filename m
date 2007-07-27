Return-Path: <linux-kernel-owner+w=401wt.eu-S964901AbXG0RgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964901AbXG0RgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 13:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbXG0RgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 13:36:12 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:32963 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757080AbXG0RgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 13:36:11 -0400
Date: Fri, 27 Jul 2007 18:41:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Lee Howard <faxguy@howardsilvan.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Robert Hancock <hancockr@shaw.ca>, linux-serial@vger.kernel.org,
       tytso@mit.edu, rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: serial flow control appears broken
Message-ID: <20070727184138.0490bf89@the-village.bc.nu>
In-Reply-To: <46AA2748.80703@howardsilvan.com>
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no>
	<46A84B4A.6070902@shaw.ca>
	<46A8C6F1.4080309@howardsilvan.com>
	<Pine.LNX.4.64N.0707271216410.425@blysk.ds.pg.gda.pl>
	<46AA2748.80703@howardsilvan.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I had previously thought that the control of RTS was something that the 
> serial/tty driver was supposed to do independently based on the buffer 
> fill.  Was I wrong?

If the kernel is asked to do CRTSCTS then the kernel handles the flow
control. It uses it when the internal buffers are nearly full.

The direct access to the lines is normally only used by special drivers
such as half duplex radio modem drivers.
