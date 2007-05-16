Return-Path: <linux-kernel-owner+w=401wt.eu-S1762682AbXEPTPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762682AbXEPTPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 15:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755753AbXEPTPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 15:15:10 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:5956 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753152AbXEPTPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 15:15:09 -0400
Message-ID: <464B5827.60905@interia.pl>
Date: Wed, 16 May 2007 21:14:47 +0200
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 1.5.0.10 (X11/20070321)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Problem with 82365SL driver in 2.6.21.1
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
X-EMID: 6071eacc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have problem with PC card slot in Wyse 3360SE terminal. 
Card insertion or removal is detected, but nothing more. 
I tried two different cards. Same behaviour.

Hardware is:
> Intel ISA PCIC probe:
>   Intel i82365sl A step ISA-to-PCMCIA at port 0x3e0 ofs 0x00, 1 socket
>     host opts [0]: none
>     ISA irqs (default) = 3,4,5,7,9,10,11,12,14,15 polling interval = 1000 ms
Dmesg after inserting card:
> pccard: PCMCIA card inserted into slot 0

I have similar hardware in other machine:
>  Intel i82365sl B step ISA-to-PCMCIA at port 0x3e0 ofs 0x00, 2 sockets
>    host opts [0]: none
>    host opts [1]: none
>    ISA irqs (scanned) = 3,4,7,9,11,12 status change on irq 11
Which is working:
> pccard: PCMCIA card inserted into slot 0
> cs: memory probe 0x0d0000-0x0dffff: excluding 0xd0000-0xd1fff
> cs: memory probe 0x0e0000-0x0effff: clean.
> pcmcia: registering new device pcmcia0.0

I checked 82365 registers. Wyse has 0x82 at offset 0 and 0 at 
offset 6. In working case it is 0x83 at offset 0 and 1 at offset 6. 
Next differences at and above 0x10 offset.

I tried all "pccardctl" options. No change. Please point me direction 
in which I should search for solution. I don't know if it is important: 
after reboot 82365 isn't detected at all on Wyse.

Please CC me.

Thank You
Rafa³

----------------------------------------------------------------------
Daj ogloszenie za darmo do nowego serwisu Populada >>>http://link.interia.pl/f1a89

