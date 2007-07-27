Return-Path: <linux-kernel-owner+w=401wt.eu-S937179AbXG0Le0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937179AbXG0Le0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 07:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936958AbXG0LdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 07:33:05 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:4359 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936926AbXG0Lc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 07:32:58 -0400
Date: Fri, 27 Jul 2007 12:32:54 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Lee Howard <faxguy@howardsilvan.com>
cc: Robert Hancock <hancockr@shaw.ca>, linux-serial@vger.kernel.org,
       tytso@mit.edu, rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: serial flow control appears broken
In-Reply-To: <46A8C6F1.4080309@howardsilvan.com>
Message-ID: <Pine.LNX.4.64N.0707271216410.425@blysk.ds.pg.gda.pl>
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no> <46A84B4A.6070902@shaw.ca>
 <46A8C6F1.4080309@howardsilvan.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007, Lee Howard wrote:

> If the application were to use TIOCM_RTS how would it know when to apply it or
> not?  Is there some approach that the application could take to manage flow
> control on the serial port?  What about software flow control?  Does the

 Well, an application could negate RTS when it receives a character and 
is running out of resources for further processing of incoming data.

 Smarter UARTs may be able to negate RTS themselves based on the amount of 
data in their receive FIFO.  The threshold may be configurable.

  Maciej
