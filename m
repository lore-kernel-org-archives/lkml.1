Return-Path: <linux-kernel-owner+w=401wt.eu-S939143AbXG3Jjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939143AbXG3Jjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 05:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764122AbXG3JjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 05:39:24 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:1720 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879AbXG3JjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 05:39:23 -0400
Date: Mon, 30 Jul 2007 10:39:20 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Paul Fulghum <paulkf@microgate.com>
cc: Robert Hancock <hancockr@shaw.ca>, Lee Howard <faxguy@howardsilvan.com>,
       linux-serial@vger.kernel.org, tytso@mit.edu, rmk@arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: serial flow control appears broken
In-Reply-To: <1185563133.23486.5.camel@x2.microgate.com>
Message-ID: <Pine.LNX.4.64N.0707301037090.12082@blysk.ds.pg.gda.pl>
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no>  <46A84B4A.6070902@shaw.ca>
 <46A8C6F1.4080309@howardsilvan.com>  <Pine.LNX.4.64N.0707271216410.425@blysk.ds.pg.gda.pl>
  <46AA2748.80703@howardsilvan.com>  <Pine.LNX.4.64N.0707271825220.425@blysk.ds.pg.gda.pl>
  <46AA3801.7090204@shaw.ca> <1185563133.23486.5.camel@x2.microgate.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2007, Paul Fulghum wrote:

> I can't see anyplace in serial_core.c or 8250.c that sets TTY_OVERRUN.

 Look for UART_LSR_OE in 8250.c -- the serial core accepts any bit that 
has been defined by the low-level driver and sets TTY_OVERRUN in 
uart_insert_char().

  Maciej
