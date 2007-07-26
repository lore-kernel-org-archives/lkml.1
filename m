Return-Path: <linux-kernel-owner+w=401wt.eu-S932259AbXGZMeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259AbXGZMeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 08:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755476AbXGZMe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 08:34:26 -0400
Received: from atlas.informatik.uni-freiburg.de ([132.230.150.3]:43226 "EHLO
	atlas.informatik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756538AbXGZMeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 08:34:25 -0400
Date: Thu, 26 Jul 2007 14:34:20 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
To: Lee Howard <faxguy@howardsilvan.com>
Cc: linux-serial@vger.kernel.org, tytso@mit.edu, rmk@arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: serial flow control appears broken
Message-ID: <20070726123420.GA14163@informatik.uni-freiburg.de>
Mail-Followup-To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@informatik.uni-freiburg.de>,
	Lee Howard <faxguy@howardsilvan.com>, linux-serial@vger.kernel.org,
	tytso@mit.edu, rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org
References: <46A7FE6A.4030309@howardsilvan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46A7FE6A.4030309@howardsilvan.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Organization: Universitaet Freiburg, Institut f. Informatik
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> This is evidenced in hardware flow control by a little LED labeled "RTS" 
> that is on the external modem.  This LED lights up when pin 7 of the DB9 
> serial connection is given +12Vdc current (signalling "RTS" is on - that 
> the host can accept data).  The LED goes dark when the current is 
> removed (signalling that the host cannot accept data).  This "RTS" LED 
> never flickers at all, as it should, when receiving these bursts of data 
> - the LED stays lit as long as the serial cable is connected to the 
> host... and yet I will see those "input overrun" messages.  Thus, it 
> seems quite clear that the Linux serial tty driver is not deasserting 
> RTS as it should in hardware flow control.  (And probably the analogous 
> problem exists in software flow control, too.)
I don't know the relevant timings for problem, but just to be sure that
your prerequisites are correct:  How did you check that the LED stays
lit all the time?  Just from looking might not be accurate.  You might
want to mesure the signal with an oscilloscope.

Just my 0.02¢
Uwe

-- 
Uwe Kleine-König

fib where fib = 0 : 1 : zipWith (+) fib (tail fib)
