Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613Ab0BPHCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 02:02:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60254 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384Ab0BPHC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 02:02:28 -0500
Message-ID: <4B7A42EB.3070405@zytor.com>
Date: Mon, 15 Feb 2010 23:02:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: david@lang.hm
CC: Neil Brown <neilb@suse.de>, Michael Evans <mjevans1983@gmail.com>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Linux mdadm superblock question.
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan> <4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com> <4B77044B.1020609@zytor.com> <20100216112708.4a863f86@notabene.brown> <4B79F3CE.5030907@zytor.com> <alpine.DEB.2.00.1002151916280.5135@asgard.lang.hm>
In-Reply-To: <alpine.DEB.2.00.1002151916280.5135@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2010 07:18 PM, david@lang.hm wrote:
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
>

LILO also can be stuffed in the MBR (and then uses block-pointers from 
there).  There is one more option that I didn't mention, which is to put 
the bootloader of a separate partition, OS/2 style.  Again, breaks the 
standard chainloading model.

	-hpa
