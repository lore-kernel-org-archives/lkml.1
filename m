Return-Path: <linux-kernel-owner+w=401wt.eu-S1756250AbYIGUtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbYIGUtO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 16:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755564AbYIGUs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 16:48:58 -0400
Received: from nat.xms.se ([212.181.93.157]:61667 "EHLO arwen.xms.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754871AbYIGUs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 16:48:57 -0400
Message-ID: <48C43E30.6020504@xms.se>
Date: Sun, 07 Sep 2008 22:48:48 +0200
From: "Jonas Petersson" <jonas.petersson@xms.se>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
CC: Owen Martin <omartin@netezza.com>, Justin Piszcz <jpiszcz@lucidpixels.com>,
       linux-ide@vger.kernel.org, smartmontools-support@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [smartmontools-support] exception Emask 0x0 SAct 0x0 SErr 0x0
 action 0x2 frozen
References: <48B91198.3020803@xms.se><alpine.DEB.1.10.0808300708330.19513@p34.internal.lan><48B9AE15.7010605@xms.se><alpine.DEB.1.10.0808301710380.11166@p34.internal.lan><48B9C261.4010609@xms.se> <alpine.DEB.1.10.0808301804290.11166@p34.internal.lan> <FAF797E46D786344A7C36218608F791C01F3ABA5@mail1.netezza.com> <48BD6086.1030101@xms.se>
In-Reply-To: <48BD6086.1030101@xms.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the record:

Jonas Petersson wrote:
> Owen Martin wrote:
>  > This looks like a timeout during a read command:
>  >
>  > ata3.00: cmd c8/00:08:90:3c:59
>  >
>  > Read dma of 8 blocks from 0x903c59
>  >
>  > Next time it happens, see if it is the same LBA. Since the drive came
>  > back after the bus reset makes me think it was probably in error
>  > recovery for an extended amount of time.
> 
> Sounds like a good idea. However, I had the drive swapped yesterday and 
> have now reinstalled on a (seemingly) identical one which so far seems 
> to be free from these messages. Hence, I keep my fingers crossed that 
> this was indeed a hw error.
 > [...]

I've now stressed the new disk for almost a week and seen no indication 
at all to the previous error. Everything else is the same as before - I 
even installed from the very same DVD. My conclusion is therefore that I 
really had a disk that was broken in a way that normal tests will not 
detect.

Hence, my tip to anyone having a similar experience: Don't blame the 
driver, nor the motherboard/chipset - just replace the drive. It would 
of course be even nicer if the error message could spell this out 
somewhat clearer too, but I guess the "I/O error" in the middle is a 
fair hint in retrospect.

			Best / Jonas


