Return-Path: <linux-kernel-owner+w=401wt.eu-S1753740AbXJVROg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbXJVROg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 13:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbXJVRO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 13:14:28 -0400
Received: from client062.sevenl.net ([66.241.137.62]:2185 "EHLO pcburn.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbXJVRO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 13:14:26 -0400
Message-ID: <471CDA66.2020004@pcburn.com>
Date: Mon, 22 Oct 2007 13:14:14 -0400
From: Chris Bergeron <chris@pcburn.com>
Reply-To: chris@pcburn.com
Organization: PCBurn Media
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrey Panin <pazke@donpac.ru>
Subject: Re: Syba 8-Port Serial Card Unidentified By Kernel
References: <4706AD19.4040605@pcburn.com> <20071010095432.GC30345@pazke.donpac.ru> <470E5714.4040303@pcburn.com> <20071012120826.GB23378@pazke.donpac.ru> <47150B06.3040306@pcburn.com> <20071017064219.GB1953@pazke.donpac.ru> <471689DA.4070008@pcburn.com> <20071018055755.GA9561@pazke.donpac.ru> <47179116.2070505@pcburn.com> <20071022153323.GA8123@pazke.donpac.ru>
In-Reply-To: <20071022153323.GA8123@pazke.donpac.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Panin wrote:
> On 291, 10 18, 2007 at 01:00:06 -0400, Chris Bergeron wrote:
>   
> So the card probably generates screaming interrupt... that's bad.
> I found some docs for IT887x chips, according to these docs  IT887x
> have simple interrupt controller inside. Further investigation is needed.
>
> Can you post output of lspci -xxx ?
>
>   
Full output at 
http://pcburn.com/files/Syba_serial_controller/lspci_xxx.out.  The 
relevant part for the Syba card is probably:

01:08.0 Serial controller: PLX Technology, Inc. Unknown device 9016 (rev 01)
00: b5 10 16 90 07 00 80 02 01 02 00 07 00 00 00 00
10: 01 a4 00 00 01 a8 00 00 01 ac 00 00 00 00 00 f5
20: 00 10 00 f5 00 20 00 f5 00 00 00 00 4e 54 08 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 05 01 00 00
40: 3f 3f 08 00 00 8c 20 8b 45 54 55 45 00 00 10 d2
50: 01 01 71 03 01 03 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 03 00 06 f8 03 f8 02
80: 78 03 78 07 00 08 00 07 00 01 20 01 40 01 60 01
90: 00 00 00 00 00 00 00 00 00 00 00 00 70 43 25 64
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00


-- Chris
