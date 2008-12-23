Return-Path: <linux-kernel-owner+w=401wt.eu-S1751784AbYLWPtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbYLWPtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 10:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbYLWPta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 10:49:30 -0500
Received: from lucidpixels.com ([75.144.35.66]:52190 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbYLWPt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 10:49:29 -0500
Date: Tue, 23 Dec 2008 10:49:28 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Christoph Hellwig <hch@infradead.org>
cc: linux-raid@vger.kernel.org, bug-parted@gnu.org,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.27.10: cannot mount xfs filesystem partition (12TiB) after
 reboot
In-Reply-To: <20081223145431.GA31057@infradead.org>
Message-ID: <alpine.DEB.1.10.0812231043540.9812@p34.internal.lan>
References: <alpine.DEB.1.10.0812230829420.4817@p34.internal.lan> <20081223134247.GA17750@infradead.org> <alpine.DEB.1.10.0812230950120.7572@p34.internal.lan> <20081223145431.GA31057@infradead.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 23 Dec 2008, Christoph Hellwig wrote:

> On Tue, Dec 23, 2008 at 09:50:26AM -0500, Justin Piszcz wrote:
>>
>>
>> On Tue, 23 Dec 2008, Christoph Hellwig wrote:
>>
>>> On Tue, Dec 23, 2008 at 08:36:17AM -0500, Justin Piszcz wrote:
>>>> Kernel = 2.6.27.10
>>>> Parted = 1.8.8.git.2008.03.24-11.1
>>>>
>>>> Can anyone help explain the problem here?
>>>
>>> Can you post your kernel .config file?
>>>
>>
>> http://home.comcast.net/~jpiszcz/20081223/config-2.6.27.10.txt
>
> Without CONFIG_EFI_PARTITION the kernel won't find your gpt labels.  See
>
> 	http://xfs.org/index.php/XFS_FAQ#Q:_Why_does_my_.3E_2TB_XFS_partition_disappear_when_I_reboot_.3F
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Christoph,

Thank you-- enabled, rebooted, success.

Steps performed/location in menuconfig:

$ make menuconfig
$ File systems
$ Partition Types
$ Hit 'Y'
$ Enable this: [X] EFI GUID Partition support (NEW)

Better question as well, need to find out if KNOPPIX or distro-CDs support 
this option, if one to boot into recovery and this option was not 
enabled.. that would not be fun.

Justin.
