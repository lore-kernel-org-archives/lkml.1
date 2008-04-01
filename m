Return-Path: <linux-kernel-owner+w=401wt.eu-S1758095AbYDAQ2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbYDAQ2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 12:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754794AbYDAQ2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 12:28:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48313 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbYDAQ2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 12:28:12 -0400
Message-ID: <47F26278.5070009@zytor.com>
Date: Tue, 01 Apr 2008 09:27:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Artem Bityutskiy <dedekind@yandex.ru>
CC: Andi Kleen <andi@firstfloor.org>, Tomasz Chmielewski <mangoo@wpkg.org>,
       LKML <linux-kernel@vger.kernel.org>, penberg@cs.helsinki.fi,
       =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>,
       ext-adrian.hunter@nokia.com, jwboyer@gmail.com
Subject: Re: UBIFS vs Logfs (was [RFC PATCH] UBIFS - new flash file system)
References: <47F1EC20.6050600@wpkg.org> <47F1F644.4060000@yandex.ru> <878wzx25s7.fsf@basil.nowhere.org> <47F21B47.4000206@yandex.ru>
In-Reply-To: <47F21B47.4000206@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy wrote:
> Andi Kleen wrote:
>> Artem Bityutskiy <dedekind@yandex.ru> writes:
>>
>>> Tomasz Chmielewski wrote:
>>>> For me, the motivators to wait for LogFS are mainly the facts that it
>>>> can work on traditional block devices, and not only on pure flash:
>>> Sorry Thomasz, for me this makes zero sense. There are _much_ better 
>>> file
>>> systems for block devices.
>>
>> I think he refers to flash disks appearing as block devices, like
>> usb sticks or similar.
> 
> Right, I also meant that in my opinion it makes more sense to use 
> traditional
> file-systems like ext3 on USB-key/MMC and the like stuff (which I 
> confusingly
> referred as "block devices"), or may be something more "heavy-weight" like
> XFS or JFS (never tried them, though).
> 

Well, even auto-levelling storage should benefit from a filesystem which 
minimizes the total number of flash sectors churned, which means doing 
as few writes as possible and to large, contiguous sections.

	-hpa
