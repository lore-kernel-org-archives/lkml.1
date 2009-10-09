Return-Path: <linux-kernel-owner+w=401wt.eu-S1760908AbZJIRE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760908AbZJIRE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 13:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756828AbZJIRE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 13:04:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60442 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137AbZJIRE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 13:04:58 -0400
Message-ID: <4ACF6CF8.4060204@zytor.com>
Date: Fri, 09 Oct 2009 10:03:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Michael Tokarev <mjt@tls.msk.ru>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: wrong final bzImage build (regading #14270)
References: <4ACF460E.7000901@msgid.tls.msk.ru> <20091009145825.GE5311@lenovo>
In-Reply-To: <20091009145825.GE5311@lenovo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2009 07:58 AM, Cyrill Gorcunov wrote:
> Peter and Sam CC'ed
> 
> [Michael Tokarev - Fri, Oct 09, 2009 at 06:17:50PM +0400]
>> Ok, finally the mystery solved.  After a week of
>> digging.
>>
>> The original problem was titled "Cannot boot on
>> a PIII Celeron", and Rafael filed a bug #14270
>> for this.
>>
>> In short, what I observed was that a new kernel
>> (2.6.31) fails to boot on a PIII Celeron machine.
>> But changing just the CPU to plain PIII and voila,
>> it now works.  I don't know why it behaved this
>> way, but I found where was the problem, finally.
>>

We should switch to printf here.  Hexadecimal constants in echo aren't
guaranteed by POSIX.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

