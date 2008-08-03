Return-Path: <linux-kernel-owner+w=401wt.eu-S1758377AbYHCPTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377AbYHCPTU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 11:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756204AbYHCPTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 11:19:06 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:51370 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859AbYHCPTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 11:19:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FzKmTsCKS77NoKCOT/Tk8S854nUorSKAzACoveXTuYFbD2w70bhNk1bHLraw1daXjn
         8xzLwzDZdkR2+Lg/JpZHwYE3Q1IYvGbH4boQMxNb54F40S99Ly9iawjVYp9ymR+YlWV3
         rAFI9eMyCnHpPXSzgZ4yZpmj9VRST1fWJOu04=
Message-ID: <4895CC61.6040301@gmail.com>
Date: Sun, 03 Aug 2008 22:18:57 +0700
From: Hong Tran Duc <hongtd2k@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Oops when read/write or mount/unmount continuously ~ 600.000
 times
References: <4895A96E.2040303@gmail.com> <20080803133817.GG26461@parisc-linux.org>
In-Reply-To: <20080803133817.GG26461@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Sun, Aug 03, 2008 at 07:49:50PM +0700, Hong Tran Duc wrote:
>   
>> The reasons is almost linked list on those function was broken. Ex: 
>> linkedlist->next linkedlist->prev = NULL or set to invalid address.
>> In the situation SIGILL, the instruction pointer (NIP) is same as the 
>> return address register (LR).
>>     
>
> In later kernels, we have a list debugging option which lets you find
> list corruptions earlier.
>   
I'm not have much experience with linux kernel architecture, so I don't 
know where I can focus on.

Currently, I'm suspecting these module are affected with this Oops: 
Block I/O management and filesystem, some Wait Queue  ? Is that correct ?
Or would you give me some suggestion what is the most suspicious ? or 
some debugging option you told above ?

Thanks for your help,


-- 
nm.

GPG Key ID: 0xDD253B25
Fingerprint: 2B17 D64A 9561 A443 2ABC 1302 4641 D0B7 DD25 3B25

