Return-Path: <linux-kernel-owner+w=401wt.eu-S1752719AbYKALyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbYKALyh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 07:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbYKALy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 07:54:29 -0400
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:3200 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbYKALy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 07:54:28 -0400
X-Greylist: delayed 686 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Nov 2008 07:54:28 EDT
Message-ID: <490C4365.4070805@shikadi.net>
Date: Sat, 01 Nov 2008 21:54:13 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.8.1.16) Gecko/20080727 Thunderbird/2.0.0.16 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Dmitry Melekhov <dm@belkam.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: serial port problem
References: <490C3D92.5060106@belkam.com>
In-Reply-To: <490C3D92.5060106@belkam.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I connected zyxel modem to port and I see that it gets commsnds- it's
> data lamp blinks, but I get nothing.
> Situation is different on my colleague machine- since ubuntu 8.04 he can
> see in minicom or gtkterm how  connected router boots,
> but then he can't send someting over several port to router.
> I created bug report in ubuntu's launchpad, but there is no solution.
> As I now see this problem exists with kernel from kernel.org could you
> tell me how can I find where problem is?

I had a similar problem trying to get a dial-up modem working a couple 
of months ago.  I could use minicom to connect to the modem and type AT 
commands and read the responses, but whenever I dialled up I would see 
"CONNECT 48000" and that would be it.  I couldn't send or receive data 
from the other end.  After about a minute the ISP I was calling would 
time out and disconnect me.

I have no idea what the problem was, I even went to the trouble of 
buying extra serial ports on a PCI card thinking the hardware was 
faulty, but nothing helped.  In the end I downgraded to 2.6.17.8 (as 
this version was running on another PC that worked fine with the modem) 
and suddenly the whole thing worked perfectly.

So it looks like some bug was introduced into the serial driver at some 
point, and if you're having problems it must still be in the current 
kernel version.  I would suggest trying 2.6.17.8 instead (as that worked 
for me), and if it works for you too you might want to try upgrading 
until you find which version stops working - then we will know when the 
problem was first introduced.

Cheers,
Adam.

