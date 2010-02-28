Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968673Ab0B1DSR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 22:18:17 -0500
Received: from mx2.isti.cnr.it ([194.119.192.4]:4286 "EHLO mx2.isti.cnr.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966874Ab0B1DSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 22:18:16 -0500
Date: Sun, 28 Feb 2010 01:56:22 +0100
From: Asdo <asdo@shiftmail.org>
Subject: Re: EXT4 is ~2X as slow as XFS (593MB/s vs 304MB/s) for writes?
In-reply-to: <alpine.DEB.2.00.1002261953350.8247@p34.internal.lan>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-id: <4B89BF36.3030901@shiftmail.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
X-INSM-ip-source: 84.223.80.88 Auth Done
References: <alpine.DEB.2.00.1002261922010.8247@p34.internal.lan>
 <87zl2vsdxs.fsf@openvz.org>
 <alpine.DEB.2.00.1002261953350.8247@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
>
>
> On Sat, 27 Feb 2010, Dmitry Monakhov wrote:
>
>> Justin Piszcz <jpiszcz@lucidpixels.com> writes:
>>
>>> Hello,
>>>
>>> Is it possible to 'optimize' ext4 so it is as fast as XFS for writes?
>>> I see about half the performance as XFS for sequential writes.
>>>
>>> I have checked the doc and tried several options, a few of which are 
>>> shown
>>> below (I have also tried the commit/journal_async/etc options but 
>>> none of
>>> them get the write speeds anywhere near XFS)?
>>>
>>> Sure 'dd' is not a real benchmark, etc, etc, but with 10Gbps between 2
>>> hosts I get 550MiB/s+ on reads from EXT4 but only 100-200MiB/s write.
>>>
>>> When it was XFS I used to get 400-600MiB/s for writes for the same RAID
>>> volume.
>>>
>>> How do I 'speed' up ext4?  Is it possible?
Hi Justin
sorry for being OT in my reply (I can't answer your question unfortunately)
You can really get 550MiB/sec through a 10gigabit ethernet connection?
I didn't think it was possible. Just a few years ago it seems to me 
there were problems in obtaining a full gigabit out of 1Gigabit ethernet 
adapters...
Is it running some kind of offloading like TOE, or RDMA or other magic 
things? (maybe by default... you can check something with ethtool 
--show-offload eth0, but TOE isn't there)
Or really computers became so fast and I missed something...?
Sorry for the stupid question
(pls note: I removed most CC recipients because I went OT)

Thank you
