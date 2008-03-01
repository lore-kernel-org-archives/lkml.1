Return-Path: <linux-kernel-owner+w=401wt.eu-S1758530AbYCASqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530AbYCASqt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 13:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbYCASql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 13:46:41 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:34485 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754096AbYCASqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 13:46:40 -0500
Date: Sat, 1 Mar 2008 20:45:15 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Alexey Starikovskiy <aystarik@gmail.com>
Cc: lenb@kernel.org, astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] acpi/battery.c: make 2 functions static
Message-ID: <20080301184515.GD25835@cs181133002.pp.htv.fi>
References: <20080301161902.GN25835@cs181133002.pp.htv.fi> <47C99FE1.8080206@gmail.com> <20080301183550.GC25835@cs181133002.pp.htv.fi> <47C9A3B3.4080401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47C9A3B3.4080401@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2008 at 09:42:59PM +0300, Alexey Starikovskiy wrote:
> Adrian Bunk wrote:
>> On Sat, Mar 01, 2008 at 09:26:41PM +0300, Alexey Starikovskiy wrote:
>>   
>>> May I keep them inline?
>>>     
>>
>> The problem with such manual inlines is that we force gcc to always  
>> inline them - and history has shown that functions grow without the  
>> "inline" being removed.
>>
>>   And for static functions gcc should (at least in theory) know best 
>> when to inline them.
>>
>>   
> Right. Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>
>
> As I understand, you have some automation tools for finding out these
> non-static functions, etc; are they available somewhere?

Type "make namespacecheck" after compiling the kernel.  

> Regards,
> Alex.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

