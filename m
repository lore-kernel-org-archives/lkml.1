Return-Path: <linux-kernel-owner+w=401wt.eu-S1762815AbZAGWrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762815AbZAGWrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:47:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762380AbZAGWri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:47:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54352 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbZAGWrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:47:36 -0500
Message-ID: <49653116.70702@zytor.com>
Date: Wed, 07 Jan 2009 14:47:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: initrd panic
References: <86802c440901071357j3dd03b2ax9b79735fd374e94d@mail.gmail.com> <20090107215914.GB17917@elte.hu> <49652ED1.6050808@kernel.org>
In-Reply-To: <49652ED1.6050808@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>>>
>>> wonder if LZMA B2ZIP etc into tip/master today broke it?
>> you enabled:
>>
>>  CONFIG_KERNEL_LZMA=y
>>  CONFIG_RD_LZMA=y
> no
>> ? Or did the normal zlib decompressor break?
> looks like
> 

What is the configuration like?

The zlib compressor is different code, but it is the code already used 
by all the other kernel modules, so unless there is a bug in the wrapper 
code it seems unlikely.

	-hpa
