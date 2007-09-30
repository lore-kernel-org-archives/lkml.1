Return-Path: <linux-kernel-owner+w=401wt.eu-S1752908AbXI3UmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbXI3UmV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 16:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbXI3UmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 16:42:06 -0400
Received: from lucidpixels.com ([75.144.35.66]:47441 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbXI3UmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 16:42:05 -0400
Date: Sun, 30 Sep 2007 16:42:04 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Sinisa Bandin <sinisa@bandin.homelinux.com>
cc: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org,
       samba@lists.samba.org, submit@bugs.debian.org, contact_us@realtek.com
Subject: Re: [Samba] 2.6.22/realtek bug in hardware, any kernel work-around?
In-Reply-To: <4700092C.5060805@bandin.homelinux.com>
Message-ID: <Pine.LNX.4.64.0709301639290.10027@p34.internal.lan>
References: <Pine.LNX.4.64.0709291349160.5726@p34.internal.lan>
 <Pine.LNX.4.64.0709291434530.8080@p34.internal.lan> <4700092C.5060805@bandin.homelinux.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 30 Sep 2007, Sinisa Bandin wrote:

>
> Justin Piszcz wrote:
>> Package: samba
>> Version: 3.0.26a-1
>>> 
>>> Kernel: 2.6.22
>>> 
>>> samba 3.0.26a-1 performance < 900 KiB/s, but FTP = 30-90 MiB/s
>>> 
>>> Let me start out by saing this is an oddball problem:
>>> 
>>> SAMBA:
>>> LINUX -> WINDOWS = < 900 KiB/s (varies between 100 - 900 KiB/s)
>>> WINDOWS -> LINUX = 30-90 MiB/s (always)
>>> 
>>> FTP:
>>> Either direction, 30-90 MiB/s (always)
>>> 
>>> I do not see any nasty errors in the logs even with verbose = 5.
>>> 
>>> Any ideas here? I am not using any special options.
>> 
>> I found out that poor smb performance is related to a broken udp-perfomance 
>> of the 8169 NIC in outgoing udp.
>> But, only in Gb Mode of the 8169 NIC, with 100Mbps it is ok.
>> 
> I had exactly the same problem with 100Mb/s also.
>
> Solved by disabling onboard LAN interface and inserting (US Robotics) Realtek 
> 8139 based card (10/100 Mbps).
>
> Best regards,
> Sinisa Bandin
>

Thank you for your response, so the bottom line is Realtek 1Gbps NICs are 
unreliable.  Wonder what Realtek has to say about it if they even respond, 
added them to cc list.

Justin.
