Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbZBRCcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbZBRCcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 21:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbZBRCcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 21:32:11 -0500
Received: from mail.lang.hm ([64.81.33.126]:59973 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbZBRCcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 21:32:10 -0500
Date: Tue, 17 Feb 2009 18:32:01 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Yinghai Lu <yinghai@kernel.org>
cc: Matthew Wilcox <matthew@wil.cx>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       DL-MPTFusionLinux@lsi.com
Subject: Re: mpt fusion broken sometime since 2.6.24
In-Reply-To: <499B6EEB.9040704@kernel.org>
Message-ID: <alpine.DEB.1.10.0902171831450.26625@asgard.lang.hm>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm>  <alpine.DEB.1.10.0902171343280.26625@asgard.lang.hm>  <20090217230050.GG16841@parisc-linux.org>  <alpine.DEB.1.10.0902171506500.26625@asgard.lang.hm> <86802c440902171511s1abcc0eao560df4b8fcea0e7c@mail.gmail.com>
 <alpine.DEB.1.10.0902171514120.26625@asgard.lang.hm> <499B46B2.5040601@kernel.org> <alpine.DEB.1.10.0902171537260.26625@asgard.lang.hm> <499B6BF7.9090300@kernel.org> <alpine.DEB.1.10.0902171803040.26625@asgard.lang.hm> <499B6EEB.9040704@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Feb 2009, Yinghai Lu wrote:

> david@lang.hm wrote:
>> On Tue, 17 Feb 2009, Yinghai Lu wrote:
>>
>>> david@lang.hm wrote:
>>>> On Tue, 17 Feb 2009, Yinghai Lu wrote:
>>>>
>>>>> david@lang.hm wrote:
>>>>>> On Tue, 17 Feb 2009, Yinghai Lu wrote:
>>>>>>
>>>>>>> Subject: Re: mpt fusion broken sometime since 2.6.24
>>>>>>>
>>>>>>> On Tue, Feb 17, 2009 at 3:07 PM,  <david@lang.hm> wrote:
>>>>>>>> On Tue, 17 Feb 2009, Matthew Wilcox wrote:
>>>>>>>>
>>>>>>>>> On Tue, Feb 17, 2009 at 01:44:55PM -0800, david@lang.hm wrote:
>>>>>>>>>>
>>>>>>>>>> I got a picture of the failed boot at
>>>>>>>>>> http://linux.lang.hm/linux/IMG00052.jpg
>>>>>>>>>
>>>>>>>>> The PCI-MSI line is probably indicative.  Can you try booting with:
>>>>>>>>>
>>>>>>>>> mptbase.mpt_msi_enable_sas=0
>>>>>>>>>
>>>>>>>>> and also send us an lspci -v so we can update the blacklist?
>>>>>>>>
>>>>>>>> is that disabling SAS for this system? if so, that's the wrong thing
>>>>>>>> to do
>>>>>>>> (the drives are SAS)
>>>>>>>>
>>>>>>> it only disable MSI with that mptsas.
>>>>>>> and mptsas will use ioapic routing.
>>>>>>>
>>>>>>> can you post whole bootlog?
>>>>>>
>>>>>> unfortunantly it's booting from CD and the only drives in the
>>>>>> system are
>>>>>> the ones that are not being accessed.
>>>>>
>>>>> i mean with kernel before 2.6.24..
>>>>
>>>> Ok, attached.
>>>>
>>>
>>> so your lsi 1068 is under 8132... need to double check if that chip
>>> really support MSI.
>>
>> anything I can do in the 2.6.24 kernel? or the 2.8.28.6 kernel?
>>
> for 2.6.24, it disable msi by default.
>
> for 2.6.28 please have
> mptbase.mpt_msi_enable=0
> in your boot command line.

this does let it boot.

David Lang
