Return-Path: <linux-kernel-owner+w=401wt.eu-S1756165AbXIATFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbXIATFe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 15:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbXIATFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 15:05:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53068 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376AbXIATFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 15:05:24 -0400
Message-ID: <46D9B7EF.2050109@garzik.org>
Date: Sat, 01 Sep 2007 15:05:19 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: thunder7@xs4all.nl
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev <netdev@vger.kernel.org>
Subject: Re: 2.6.23-rc4-mm1 OOPS in forcedeth?
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <20070901181352.GA4156@amd64.of.nowhere>
In-Reply-To: <20070901181352.GA4156@amd64.of.nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

thunder7@xs4all.nl wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Fri, Aug 31, 2007 at 09:58:22PM -0700
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc4/2.6.23-rc4-mm1/
>>
> On this machine (Athlon 64 X2 4600, 4 GiB memory, lots of disks),
> 2.6.23-rc1-mm2 runs fine. 2.6.23-rc4-mm1 reproducably dies within seconds of starting
> a rsync session on another PC against this machine.
> 
> NULL pointer dereference
> code:	nv_napi_poll+0x108
> trace:	net_rx_action+0xab
> 	__do_softirq+0x74
> 	call_softirq+0x1c
> 	do_softirq+0x3d
> 	irq_exit+0x85
> 	do_IRQ+0x85
> 	ret_from_intr+0x0

(added netdev to CC)

I'm guessing that this is net-2.6.24.git's NAPI update.

	Jeff


