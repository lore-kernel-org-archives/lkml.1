Return-Path: <linux-kernel-owner+w=401wt.eu-S1756239AbXFYFDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbXFYFDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 01:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbXFYFDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 01:03:38 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:48993 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbXFYFDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 01:03:37 -0400
Message-ID: <467F063A.2030805@rossove.com>
Date: Sun, 24 Jun 2007 19:03:06 -0500
From: David Jones <djones@rossove.com>
Reply-To: djones@rossove.com
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Robert Iakobashvili <coroberti@gmail.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Scaling Max IP address limitation
References: <467EA7C1.4080006@rossove.com>	 <20070624110236.fa36b2f9.akpm@linux-foundation.org> <7e63f56c0706241259u6e123ed6yc02b76f0260adaa5@mail.gmail.com>
In-Reply-To: <7e63f56c0706241259u6e123ed6yc02b76f0260adaa5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Iakobashvili wrote:
> Hi,
>
>> On Sun, 24 Jun 2007 12:20:01 -0500 David Jones <djones@rossove.com> 
>> wrote:
>
>> > I am trying to add multiple IP addresses ( v6 ) to my FC7 box on eth0.
>> > But I am hitting a max limit of 4000 IP address . Seems like there 
>> is a
>> > limiting variable in linux kernel (which one? ) that prevents from
>> > adding more IP addresses than 4096. What do I need to change in Linux
>> > kernel  ( and then recompile ) to be able to add more IP addresses 
>> than
>> > 4K addresses per system? ..
>
>
> We are adding tens of thousand IPv4 addresses using netlink interface
> without any problems. The maximum we added was 60K of secondary
> IPv4 addresses. It consumes some memory, however.
>
> We have also added thousands of IPv6. I will try to test, if there is any
> limit for doing it.
>

I am using the "ip add " command looping sequentially up until RTNETLINK 
starts refusing to add more IP addresses. I am using a simple shell 
script to do the trick. One quick fact : If I exhaust 4K addresses on 
one port , then I can not add more IP's  ( v4/v6 alike ) on any port on 
the system. So seems like its a system wide limitation . Tried digging 
through the kernel source code but no luck so far. So definitely need 
pointers in this regard.
How are you adding via Netlink interface ?
Thanks,
-d
