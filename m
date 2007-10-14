Return-Path: <linux-kernel-owner+w=401wt.eu-S1763857AbXJNVg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763857AbXJNVg7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 17:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759698AbXJNVgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 17:36:51 -0400
Received: from b.mail.sonic.net ([64.142.19.5]:34873 "EHLO b.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758621AbXJNVgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 17:36:51 -0400
References: <47114B46.10403@sonic.net> <1192393469.7573.8.camel@heimdal.trondhjem.org> <47127FA8.6040506@sonic.net> <1B7E8ED9-7DA9-41CA-BDF9-219E71AAA905@screamingdolphin.net> <4712835C.5050400@sonic.net> <1192397541.7573.13.camel@heimdal.trondhjem.org>
Message-Id: <38BD90D6-E300-4B7B-8244-C898A9A3AA0B@sonic.net>
From: Scott Petler <scottp@sonic.net>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
In-Reply-To: <1192397541.7573.13.camel@heimdal.trondhjem.org>
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
X-Mailer: iPhone Mail (3A109a)
Mime-Version: 1.0 (iPhone Mail 3A109a)
Subject: Re: PROBLEM: kernel panic
Content-Transfer-Encoding: 7bit
Date: Sun, 14 Oct 2007 14:36:32 -0700
Cc: "Doug Whitesell (LKML)" <dcw-kernel@screamingdolphin.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I'll do that....
Thanks

Sent from my iPhone

On Oct 14, 2007, at 2:32 PM, Trond Myklebust  
<trond.myklebust@fys.uio.no> wrote:

>
> On Sun, 2007-10-14 at 14:00 -0700, Scott Petler wrote:
>> Doug,
>>
>> I thought that might do it, it does seem to work.  I edited the  
>> driver
>> line in my xorg.conf
>> from nvidia to nv and then,
>> <alt><ctrl> F1
>> login as root
>> /etc/init.d/gdm stop
>> /etc/init.d/gdm start
>>
>> It came back up with the same flashing crap on the second monitor,  
>> so I
>> did it again with
>> the 2nd monitor turned off altogether, and I'll see how long it  
>> will run
>> on the single monitor
>> without the nvidia driver without crashing (maybe forever...).
>>
>> Thanks,
>> Scott
>
> Please don't forget to reboot, though. The kernel will remain tainted
> until you've rebooted without loading the nvidia module.
>
> Cheers
>  Trond
>
