Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622Ab0BPEmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 23:42:51 -0500
Received: from hole.yuiop.co.uk ([89.145.97.62]:45737 "EHLO mail.yuiop.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932573Ab0BPEmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 23:42:50 -0500
Message-ID: <4B7A2250.5020909@anonymous.org.uk>
Date: Tue, 16 Feb 2010 04:42:56 +0000
From: John Robinson <john.robinson@anonymous.org.uk>
Organization: None; Disorganization: Total
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.8.1.23) Gecko/20090812 Lightning/0.9 Thunderbird/2.0.0.23 Mnenhy/0.7.6.666
MIME-Version: 1.0
CC: Linux RAID <linux-raid@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: Linux mdadm superblock question.
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan> <4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com> <4B77044B.1020609@zytor.com> <20100216112708.4a863f86@notabene.brown> <4B79F3CE.5030907@zytor.com> <alpine.DEB.2.00.1002151916280.5135@asgard.lang.hm>
In-Reply-To: <alpine.DEB.2.00.1002151916280.5135@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/02/2010 03:18, david@lang.hm wrote:
> On Mon, 15 Feb 2010, H. Peter Anvin wrote:
> 
>> On 02/15/2010 04:27 PM, Neil Brown wrote:
>>
>> There are three options:
>>
>> a) either don't boot from it (separate /boot);
>> b) use a bootloader which installs in the MBR and
>> hopefully-unpartitioned disk areas (e.g. Grub);
>> c) use a nonstandard custom MBR.
>>
>> Neither (b) or (c), of course, allow for chainloading from another OS
>> install and thus are bad for interoperability.
> 
> I have had no problems with XFS partitions and lilo as the bootloader. 
> I've been doing this for a couple of years now without realizing that 
> there is supposed to be a problem.

There isn't, if you use partitions. It could (would) go wrong if you 
tried to put an XFS filesystem, or md RAID with a v1.1 superblock, on a 
whole disc without a partition table *and* you tried to put a bootloader 
on. I can't say it's ever occurred to me to do that, because I always 
assumed that whatever I put in a partition used all of it, and I 
couldn't expect to double-book the beginning of it and have it work.

Cheers,

John.
