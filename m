Return-Path: <linux-kernel-owner+w=401wt.eu-S1760889AbXG0SNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760889AbXG0SNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 14:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754205AbXG0SM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 14:12:59 -0400
Received: from gateway.howardsilvan.com ([64.146.212.27]:52191 "EHLO
	mail.howardsilvan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbXG0SM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 14:12:58 -0400
Message-ID: <46AA355E.20901@howardsilvan.com>
Date: Fri, 27 Jul 2007 11:11:42 -0700
From: Lee Howard <faxguy@howardsilvan.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060501 Fedora/1.7.13-1.1.fc4
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Robert Hancock <hancockr@shaw.ca>, linux-serial@vger.kernel.org,
       tytso@mit.edu, rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: serial flow control appears broken
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no> <46A84B4A.6070902@shaw.ca> <46A8C6F1.4080309@howardsilvan.com> <Pine.LNX.4.64N.0707271216410.425@blysk.ds.pg.gda.pl> <46AA2748.80703@howardsilvan.com> <Pine.LNX.4.64N.0707271825220.425@blysk.ds.pg.gda.pl>
In-Reply-To: <Pine.LNX.4.64N.0707271825220.425@blysk.ds.pg.gda.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:

> The TTY line discipline driver could do that based on the amount of 
>received data present in its buffer.  And it should if asked to (a brief 
>look at drivers/char/n_tty.c reveals it does; obviously there may be a bug 
>somewhere though).  So could e.g. the SLIP and PPP line discipline 
>drivers, though the criteria might be different (apparently they do not, 
>which is a shame).
>
> The serial drivers have nothing to do about it -- all they can do is 
>pushing data upstream, to the discipline driver.  They can provide an 
>interface to hardware flow control features though, if implemented by a 
>given UART.
>

Thank you for this clarification.  So I should have more correctly been 
saying that "tty flow control appears broken".  Right?

I've asked the manufacturer to take a look at drivers/char/n_tty.c to 
see if they can't see anything obvious.

Thanks,

Lee.
