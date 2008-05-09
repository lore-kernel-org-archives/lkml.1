Return-Path: <linux-kernel-owner+w=401wt.eu-S1765569AbYEISdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765569AbYEISdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 14:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750951AbYEISdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 14:33:08 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:40181 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376AbYEISdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 14:33:07 -0400
Message-ID: <482498D5.9060008@krogh.cc>
Date: Fri, 09 May 2008 20:32:53 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: NIU - Sun Neptune 10g - Transmit timed out reset (2.6.24)
References: <4821F3B7.2090702@krogh.cc>	<86802c440805071130m62c1f4edydb3316dac4a2aba2@mail.gmail.com> <20080507.141521.193714938.davem@davemloft.net>
In-Reply-To: <20080507.141521.193714938.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: "Yinghai Lu" <yhlu.kernel@gmail.com>
> Date: Wed, 7 May 2008 11:30:18 -0700
> 
>> On Wed, May 7, 2008 at 11:23 AM, Jesper Krogh <jesper@krogh.cc> wrote:
>>> Hi.
>>>
>>>  I get errors like this after a few minutes of traffic on a Sun Neptune 10g
>>> ethernet card. (with nice 500MB/s throughput).
>>>
>>>  Then the server seems too busy with something, so it doesn't even respont
>>> to a serial terminal login.
>>>
>>>  May  7 16:16:33 hest kernel: [  166.948958] niu: niu_get_parent:
>>> platform_type[1] port[3]
>>>  May  7 16:16:33 hest kernel: [  166.949366] niu: niu_get_and_validate_port:
>>> port[3] num_ports[2]
>>>  May  7 16:16:33 hest kernel: [  166.949886] niu: niu_put_parent: port[3]
>>>  .. bootup ends here ..
>>>  May  7 17:13:54 hest kernel: [ 3670.128178] niu 0000:84:00.0: niu: eth4:
>>> Transmit timed out, resetting
>>>  May  7 17:14:04 hest kernel: [ 3680.108614] niu 0000:84:00.0: niu: eth4:
>>> Transmit timed out, resetting
>>>  May  7 17:14:14 hest kernel: [ 3690.093089] niu 0000:84:00.0: niu: eth4:
>>> Transmit timed out, resetting
>>>  May  7 17:14:19 hest kernel: [ 3695.079254] niu 0000:84:00.0: niu: eth4:
>>> Transmit timed out, resetting
>>>  May  7 17:14:24 hest kernel: [ 3700.073525] niu 0000:84:00.0: niu: eth4:
>>> Transmit timed out, resetting
>>>  May  7 17:14:29 hest kernel: [ 3705.063744] niu 0000:84:00.0: niu: eth4:
>>> Transmit timed out, resetting
>>>  May  7 17:14:34 hest kernel: [ 3710.049918] niu 0000:84:00.0: niu: eth4:
>>> Transmit timed out, resetting
>>>
>>>
>>>  Any suggestions?
>>>
>>>  The system is an Ubuntu Hardy (2.6.24-17-server) amd64.
>> can you try 2.6.25 or current git?
> 
> Also, please always CC: netdev@vger.kernel.org on networking reports.

Yes. It is reproducable under 2.6.25.2, when the load get up.. (worked 
excellent in the <100MB/s range for several hours.

When it works I doesnt seem to be able to get it pass 500MB/s.

Jesper
-- 
Jesper
