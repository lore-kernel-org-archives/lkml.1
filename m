Return-Path: <linux-kernel-owner+w=401wt.eu-S1763421AbXJRJo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763421AbXJRJo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 05:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760268AbXJRJoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 05:44:16 -0400
Received: from stinky.trash.net ([213.144.137.162]:65524 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760020AbXJRJoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 05:44:15 -0400
Message-ID: <47172AD5.2030009@trash.net>
Date: Thu, 18 Oct 2007 11:43:49 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: linux390@de.ibm.com, linux-s390@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: s390x: getting ipv6 bugs on mainline since 2.6.23-git3
References: <20071018093556.GT21136@shadowen.org>
In-Reply-To: <20071018093556.GT21136@shadowen.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> Seems we are getting some kind of bug out of our s390x partition (lnxabat1)
> when booting latest mainline releases, specifically since 2.6.23-git3.
> 
> Kernel BUG at 0000000000000002 Ýverbose debug info unavailable?
> illegal operation: 0001 Ý#1?
> Modules linked in: dm_mod sit tunnel4 ipv6 qeth ccwgroup qdio dasd_fba_mod dasd_
> eckd_mod dasd_mod
> CPU:    0    Not tainted
> Process ip (pid: 2614, task: 000000003f42f680, ksp: 000000003cf2feb8)
> Krnl PSW : 0704200180000000 0000000000000002 (0x2)
>            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:2 PM:0 EA:3
> Krnl GPRS: 0000000000000000 0000000000000000 000000003e6d5d00 000000003e01f000
>            00000000000086dd 000000003cdac144 0000000000000000 0000000000000010
>            000000003e01f000 000000003d97e3c0 0000000100eaaa00 000000003cdac100
>            000000003e6d5d00 00000001018fb1d0 0000000000286da8 000000003cf2f5e8
> Krnl Code:>0000000000000002: 0000               unknown
>            0000000000000004: 0000               unknown
>            0000000000000006: 0000               unknown
>            0000000000000008: 0000               unknown
>            000000000000000a: 0000               unknown
>            000000000000000c: 0000               unknown
>            000000000000000e: 0000               unknown
>            0000000000000010: 0000               unknown
> Call Trace:
> (Ý<0000000000286d60>? neigh_connected_output+0x68/0xfc)


Which network driver are you using? Please post the output of
"ip link list <dev>".
