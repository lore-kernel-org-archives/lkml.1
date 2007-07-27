Return-Path: <linux-kernel-owner+w=401wt.eu-S934897AbXG0Fye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934897AbXG0Fye (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 01:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760541AbXG0Fy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 01:54:26 -0400
Received: from gateway.howardsilvan.com ([64.146.212.27]:40057 "EHLO
	mail.howardsilvan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758358AbXG0FyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 01:54:25 -0400
Message-ID: <46A98845.8010806@howardsilvan.com>
Date: Thu, 26 Jul 2007 22:53:09 -0700
From: Lee Howard <faxguy@howardsilvan.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060501 Fedora/1.7.13-1.1.fc4
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Robert Hancock <hancockr@shaw.ca>, linux-serial@vger.kernel.org,
       tytso@mit.edu, rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: serial flow control appears broken
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no>	<46A84B4A.6070902@shaw.ca>	<46A8C6F1.4080309@howardsilvan.com> <20070726173121.70088a92@the-village.bc.nu>
In-Reply-To: <20070726173121.70088a92@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

>>Serial: 8250/16550 driver $Revision: 1.90 $ 8 ports, IRQ sharing enabled
>>ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
>>ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
>>
>>It's a Shuttle HOT-661 motherboard (VIA Apollo Pro Plus mainboard 
>>chipset).  Both FreeBSD and Linux identify the serial chipset type as 
>>16550A.
>>    
>>
>
>So you've got 16bytes of buffering. That ought to be enough on a modern
>PC. The older kernels use quite limited internal buffers which may be a
>factor, the current ones have a rewritten tty buffering layer which may
>improve matters enormously.
>

So, does this explain why I wouldn't have a problem at 115200 bps with 
kernel 2.2.5 but why I do with 2.6.5 and 2.6.18?  Both hardware and 
software flow control work fine with 2.2.5 (meaning I don't see any 
error message and I don't have any data corruption), but neither works 
to avoid the "kernel: ttyS1: 1 input overrun(s)" and consequent data 
corruption issue in 2.6.5 nor 2.6.18.

Was there some associated application change in tty handling that needed 
to occur between the 2.2 and 2.6 kernels to properly implement flow control?

Thanks,

Lee.
