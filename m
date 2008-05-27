Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbYE0GUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbYE0GUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 02:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755340AbYE0GUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 02:20:14 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:40595 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749AbYE0GUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 02:20:10 -0400
Message-ID: <483BA80C.4020502@krogh.cc>
Date: Tue, 27 May 2008 08:19:56 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, matheos.worku@sun.com
Subject: Re: NIU - Sun Neptune 10g - Transmit timed out reset (2.6.24)
References: <20080526.123338.161271834.davem@davemloft.net>	<20080526.123951.260448303.davem@davemloft.net>	<483B239D.4090402@krogh.cc> <20080526.151540.191673092.davem@davemloft.net>
In-Reply-To: <20080526.151540.191673092.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Jesper Krogh <jesper@krogh.cc>
> Date: Mon, 26 May 2008 22:54:53 +0200
> 
>> Applied and running.. I've now pushed 400GB of data through it trying to
>> get it to hit the bug but it is still running.
>>
>> So without saying that it solved the problem, it definately seems so.
>> 2.6.26-rc4 + above patch.
> 
> Thanks for testing.

Ok. I was too early out.. it ended up in the same situation again.

May 27 08:09:12 hest kernel: [42953871.982072] NETDEV WATCHDOG: eth4: 
transmit timed out
May 27 08:09:17 hest kernel: [42953877.827797] NETDEV WATCHDOG: eth4: 
transmit timed out
May 27 08:09:22 hest kernel: [42953883.958375] NETDEV WATCHDOG: eth4: 
transmit timed out
May 27 08:09:27 hest kernel: [42953890.668401] NETDEV WATCHDOG: eth4: 
transmit timed out


Jesper
-- 
Jesper
