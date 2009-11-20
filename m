Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbZKTRTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbZKTRTn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 12:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbZKTRTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 12:19:42 -0500
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:33336 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754281AbZKTRTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 12:19:42 -0500
Message-ID: <4B06CFB1.1090104@internode.on.net>
Date: Sat, 21 Nov 2009 03:49:45 +1030
From: indexer <indexer@internode.on.net>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: Regression in efi.c 2.6.32-rc7
References: <4B065C44.5000209@internode.on.net> <4B06CE9D.3030003@zytor.com>
In-Reply-To: <4B06CE9D.3030003@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 11/20/2009 01:07 AM, indexer wrote:
>   
>> Peter, Huang
>>
>> I have finally solved the issues i had with bisecting and have completed
>> successfully bisecting the efi issue. It exists between 2.6.30-rc7 and
>> 2.6.30-rc8.
>>
>> 9fa7eb283c5cdc2b0f4a8cfe6387ed82e5e9a3d3 is the first bad commit
>> commit 9fa7eb283c5cdc2b0f4a8cfe6387ed82e5e9a3d3
>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>> Date:   Tue Jun 2 20:07:25 2009 -0700
>>
>>     Linux 2.6.30-rc8
>>
>> :100644 100644 739fd34a72a2422f14937ccd084f77d52edc0fc1
>> 610d1c332c45d1d8d2da3adc42e0fb0ad20c7123 M    Makefile
>>
>> Is the output of git bisect. I hope this helps to find the problem and
>> resolve it
>>
>> William
>>     
>
> That can't be right.  That patch only changes the version number.
>
> 	-hpa
>
>   
This is what git bisect told me. I will redo it and expand my parameters.

William
