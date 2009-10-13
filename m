Return-Path: <linux-kernel-owner+w=401wt.eu-S1759411AbZJMK2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411AbZJMK2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 06:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759392AbZJMK2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 06:28:20 -0400
Received: from host179-6-static.238-77-b.business.telecomitalia.it ([77.238.6.179]:38384
	"EHLO mail.navynet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759368AbZJMK2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 06:28:19 -0400
Message-ID: <4AD4561A.5050109@navynet.it>
Date: Tue, 13 Oct 2009 12:27:38 +0200
From: Massimo Cetra <ctrixk@navynet.it>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: ctrixk@navynet.it, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [Bug #14378] Problems with net/core/skbuff.c
References: <r-4Wjt4coy.A.CwC.Wal0KB@chimera>	<20091012.034224.64980795.davem@davemloft.net>	<4AD44435.3050703@navynet.it> <20091013.032237.45775304.davem@davemloft.net>
In-Reply-To: <20091013.032237.45775304.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-auth-from: mcetra@navynet.it
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller ha scritto:
> From: Massimo Cetra <ctrixk@navynet.it>
> Date: Tue, 13 Oct 2009 11:11:17 +0200
>
>   
>> Here, vserver is not involved, and the problem starts at drbd which
>> lives in kernel space (the other oops started at ocfs2).
>>
>> Both ocfs2 and drbd make heavy use of network I/O so i guess the
>> problem is something in the network layer.
>>
>> Anything i can do to help to debugging and solving this issue ?
>>     
>
> Is all of your traffic going over virtio_net?
>   
Yes, indeed.
I'm compiling the patch and i'll let you know.

Thanks,
Max
