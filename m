Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbYEIXdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbYEIXdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 19:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbYEIXdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 19:33:42 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:15889 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbYEIXdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 19:33:41 -0400
Message-ID: <4824DF51.9090902@hp.com>
Date: Fri, 09 May 2008 16:33:37 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jesper Krogh <jesper@krogh.cc>
CC: David Miller <davem@davemloft.net>, yhlu.kernel@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: NIU - Sun Neptune 10g - Transmit timed out reset (2.6.24)
References: <86802c440805071130m62c1f4edydb3316dac4a2aba2@mail.gmail.com>	<20080507.141521.193714938.davem@davemloft.net>	<482498D5.9060008@krogh.cc>	<20080509.143229.174354251.davem@davemloft.net>	<4824C936.9000103@krogh.cc>	<4824CE43.8060203@hp.com> <4824D4C0.10201@krogh.cc>	<4824D830.9090504@hp.com> <4824DAB0.8060604@krogh.cc>
In-Reply-To: <4824DAB0.8060604@krogh.cc>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Krogh wrote:
> Rick Jones wrote:
> 
>>>> To which cpu(s) were the neptune's interrupts assigned? (grep <ethN> 
>>>> /proc/interrupts)
>>>
>>>
>>> Several
>>
>>
>> Which ones?-)  I suspect that since it is several that at least 
>> answers the MSI_X question right?  Or is it possible to have a single 
>> device have several MSI interrupts?

Well, the output below anwered my question about multiple MSI's from a 
single device :)

> 
> 
> The table is rather large.
> http://rafb.net/p/a9zfFA59.html

So, over time at least, the interrupts have been spread over half the 
cores in the system.  This is where the block diagram showing the socket 
and I/O slot connections would be useful.

For the interrupts over a given interval, one can take snapshots at 
either end of the interval and then run them through beforeafter:

ftp://ftp.cup.hp.com/dist/networking/tools/

I think that collectl might have something there too.


I guess the addresses in use weren't sufficient to get interrupts spread 
across all 24 IRQ's.

rick jones
