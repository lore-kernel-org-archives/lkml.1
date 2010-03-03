Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab0CCAqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:46:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:46421 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108Ab0CCAp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:45:58 -0500
Message-ID: <4B8DB3CD.6050204@kernel.org>
Date: Wed, 03 Mar 2010 09:56:45 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: werner@guyane.dyn-o-saur.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.33 problems
References: <1267290551.13148@guyane.dyn-o-saur.com> <20100302135032.e3d11bbf.akpm@linux-foundation.org>
In-Reply-To: <20100302135032.e3d11bbf.akpm@linux-foundation.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 03 Mar 2010 00:45:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/03/2010 06:50 AM, Andrew Morton wrote:
> On Sat, 27 Feb 2010 14:09:11 -0300 (GFT)
> werner@guyane.dyn-o-saur.com wrote:
> 
>> For better error searching / correction, I add below the whole syslog.
>>
>> This is refered to 2.6.33  published (without patchs)
>>
>> This are different errors.
>>
>> The most of them exists since 2.6.33-rc1 or appr. -rc5.
>>
>> I posted here already the whole syslog.bz2 but nobody toke care.
>>
>> the boot_vga error occurs only after I start the grafics mode.  It's the mainboard's embedded nvidia grafics. I use the vesa framebuffer driver of X 1.8
>>
>> the int6_init error occurs also in text mode. I think it have something to do with internet.
>>
>> Also the printk errors occur only when start the computer in the grafics mode, but not when starting it in the text mode.
>>
>> Below is also the kernel config. Its the same like since -rc7 (but the errors are also the same)

Hmmmm... it seems like the percpu allocator failed to allocate space
for a new chunk in the vmalloc area.  Looking through the config.
Hmmm, w/ 3G split, there should be enough vmalloc area.  Strange.
Does kernel parameter "percpu_alloc=page" make the machine boot?  If
so, can you please post the output of dmesg right after boot?

Thanks.

-- 
tejun
