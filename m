Return-Path: <linux-kernel-owner+w=401wt.eu-S1752365AbZHQNWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbZHQNWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 09:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbZHQNWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 09:22:39 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:62751 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbZHQNWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 09:22:38 -0400
MIME-Version: 1.0
In-Reply-To: <20090817113059.GA3245@localdomain.by>
References: <20090812201034.GA2983@localdomain.by>
	 <1250498613.28336.68.camel@minggr.sh.intel.com>
	 <20090817113059.GA3245@localdomain.by>
Date: Mon, 17 Aug 2009 21:22:39 +0800
Message-ID: <d3f22a0908170622x7dd9ce73m5c3ea86406cc9935@mail.gmail.com>
Subject: Re: acpi_ex_system_memory_space_handler oops
From: Lin Ming <lin@minggr.cn>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Lin Ming <ming.m.lin@intel.com>, "Brown, Len" <len.brown@intel.com>,
       "Moore, Robert" <robert.moore@intel.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi, Lin
>
>> 2. Debug kernel patch
>>
>> Currently, we exit the interpreter when setup region, because it may
>> execute control methods, such as _REG.
>>
>> The attached debug kernel patch (region-debug.patch) don't exit the
>> interpreter if the region is temporary, namely, it is defined inside a
>> method.
>>
>
> rc6-git2
> 25 successful reboots.
>
> I'll need some more time to test against rc5.
>
> /*should I also test DSDT in case region-debug.patch fixed the problem?*/

Yes, please also help to test the custome DSDT.
region-debug.patch is just a debug patch.
We need to root cause the problem clearly and then work out a clean solution.

Many thanks.
Lin Ming
