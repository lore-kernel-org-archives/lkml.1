Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbZISGlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbZISGlH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 02:41:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbZISGlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 02:41:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774AbZISGlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 02:41:04 -0400
Message-ID: <4AB47CFA.2010502@redhat.com>
Date: Sat, 19 Sep 2009 09:40:58 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] core, x86: Add user return notifiers
References: <1253105134-8862-1-git-send-email-avi@redhat.com> <1253105134-8862-2-git-send-email-avi@redhat.com> <4AB3CDEC.5050902@zytor.com>
In-Reply-To: <4AB3CDEC.5050902@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2009 09:14 PM, H. Peter Anvin wrote:
> On 09/16/2009 05:45 AM, Avi Kivity wrote:
>    
>> Add a general per-cpu notifier that is called whenever the kernel is
>> about to return to userspace.  The notifier uses a thread_info flag
>> and existing checks, so there is no impact on user return or context
>> switch fast paths.
>>
>> Signed-off-by: Avi Kivity<avi@redhat.com>
>>      
> The concept of this patch looks entirely sane, as does the code,
> *except* for:
>
> +#include<linux/user-return-notifier.h>
>
> ... missing header file, and ...
>
> +obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
>
> ... missing source file.
>
> Could you fix the patch, please?
>
>    

Doh.  Sent out fixed patch.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

