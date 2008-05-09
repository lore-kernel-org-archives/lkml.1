Return-Path: <linux-kernel-owner+w=401wt.eu-S1758485AbYEIWPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485AbYEIWPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 18:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758012AbYEIWPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 18:15:23 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:41883 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757857AbYEIWPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 18:15:20 -0400
Message-ID: <4824CCF0.5050302@krogh.cc>
Date: Sat, 10 May 2008 00:15:12 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Matheos Worku <Matheos.Worku@Sun.COM>
CC: David Miller <davem@davemloft.net>, yhlu.kernel@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: NIU - Sun Neptune 10g - Transmit timed out reset (2.6.24)
References: <86802c440805071130m62c1f4edydb3316dac4a2aba2@mail.gmail.com> <20080507.141521.193714938.davem@davemloft.net> <482498D5.9060008@krogh.cc> <20080509.143229.174354251.davem@davemloft.net> <4824C936.9000103@krogh.cc> <4824CBA1.8040703@sun.com>
In-Reply-To: <4824CBA1.8040703@sun.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matheos Worku wrote:
> Jesper Krogh wrote:
>> David Miller wrote:
>>> From: Jesper Krogh <jesper@krogh.cc>
>>> Date: Fri, 09 May 2008 20:32:53 +0200
>>>
>>>> When it works I doesnt seem to be able to get it pass 500MB/s.
>>>
>>> With this card you really need multiple cpus and multiple threads
>>> sending data through the card in order to fill the 10Gb pipe.
>>>
>>> Single connections will not fill the pipe.
>>
>> The server is a Sun X4600 with 8 x dual-core CPU's, setup with 64
>> NFS-threads. The other end of the fiber goes into a switch with gigabit
>> ports connected to 48 dual-core cpus. The test was done doing a dd on a
>> 4.5GB file from the server to /dev/null on the clients.
> 
> Are you doing a TX or RX (with respect to the 10G if)?

Thats a transmit.. from the NFS server to the clients.

Jesper
-- 
Jesper
