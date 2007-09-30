Return-Path: <linux-kernel-owner+w=401wt.eu-S1752938AbXI3VZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbXI3VZl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 17:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbXI3VZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 17:25:31 -0400
Received: from smtp3.neobee.net ([80.74.160.52]:45489 "EHLO smtp2.neobee.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752033AbXI3VZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 17:25:30 -0400
Message-ID: <4700092C.5060805@bandin.homelinux.com>
Date: Sun, 30 Sep 2007 22:38:04 +0200
From: Sinisa Bandin <sinisa@bandin.homelinux.com>
Reply-To: sinisa@bandin.homelinux.com
User-Agent: Thunderbird 2.0.0.7pre (X11/20070927)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org,
       samba@lists.samba.org, submit@bugs.debian.org
Subject: Re: [Samba] 2.6.22/realtek bug in hardware, any kernel work-around?
References: <Pine.LNX.4.64.0709291349160.5726@p34.internal.lan> <Pine.LNX.4.64.0709291434530.8080@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0709291434530.8080@p34.internal.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.2 (----)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Justin Piszcz wrote:
> Package: samba
> Version: 3.0.26a-1
>>
>> Kernel: 2.6.22
>>
>> samba 3.0.26a-1 performance < 900 KiB/s, but FTP = 30-90 MiB/s
>>
>> Let me start out by saing this is an oddball problem:
>>
>> SAMBA:
>> LINUX -> WINDOWS = < 900 KiB/s (varies between 100 - 900 KiB/s)
>> WINDOWS -> LINUX = 30-90 MiB/s (always)
>>
>> FTP:
>> Either direction, 30-90 MiB/s (always)
>>
>> I do not see any nasty errors in the logs even with verbose = 5.
>>
>> Any ideas here? I am not using any special options.
>
> I found out that poor smb performance is related to a broken 
> udp-perfomance of the 8169 NIC in outgoing udp.
> But, only in Gb Mode of the 8169 NIC, with 100Mbps it is ok.
>
I had exactly the same problem with 100Mb/s also.

Solved by disabling onboard LAN interface and inserting (US Robotics) 
Realtek 8139 based card (10/100 Mbps).

Best regards,
Sinisa Bandin

