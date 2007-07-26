Return-Path: <linux-kernel-owner+w=401wt.eu-S933667AbXGZQ3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933667AbXGZQ3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761481AbXGZQ32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:29:28 -0400
Received: from gateway.howardsilvan.com ([64.146.212.27]:33644 "EHLO
	mail.howardsilvan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759715AbXGZQ31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:29:27 -0400
Message-ID: <46A8CB96.1010501@howardsilvan.com>
Date: Thu, 26 Jul 2007 09:28:06 -0700
From: Lee Howard <faxguy@howardsilvan.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060501 Fedora/1.7.13-1.1.fc4
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
CC: linux-serial@vger.kernel.org, tytso@mit.edu, rmk@arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: serial flow control appears broken
References: <46A7FE6A.4030309@howardsilvan.com> <20070726123420.GA14163@informatik.uni-freiburg.de>
In-Reply-To: <20070726123420.GA14163@informatik.uni-freiburg.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Kleine-König wrote:

>Hello,
>
>  
>
>>This is evidenced in hardware flow control by a little LED labeled "RTS" 
>>that is on the external modem.  This LED lights up when pin 7 of the DB9 
>>serial connection is given +12Vdc current (signalling "RTS" is on - that 
>>the host can accept data).  The LED goes dark when the current is 
>>removed (signalling that the host cannot accept data).  This "RTS" LED 
>>never flickers at all, as it should, when receiving these bursts of data 
>>- the LED stays lit as long as the serial cable is connected to the 
>>host... and yet I will see those "input overrun" messages.  Thus, it 
>>seems quite clear that the Linux serial tty driver is not deasserting 
>>RTS as it should in hardware flow control.  (And probably the analogous 
>>problem exists in software flow control, too.)
>>    
>>
>I don't know the relevant timings for problem, but just to be sure that
>your prerequisites are correct:  How did you check that the LED stays
>lit all the time?  Just from looking might not be accurate.  You might
>want to mesure the signal with an oscilloscope.
>

The manufacturer is using a scope to look for RTS and they're not seeing 
it, either.  I just use my eyes to look at the LED, but I can see the 
CTS, DTR, DCD, RD, and TD lights blink, flicker, or dim... (and TD, RD, 
and CTS tend to go on and off rather quickly).

All of that said... even though I don't see RTS flicker or blink or dim 
when using kernel 2.2.5 (RedHat 6.0) I don't have any problems using 
115200 bps DTE-DCE communication rate.

Thanks,

Lee.
