Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbZDPJSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbZDPJSf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 05:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbZDPJSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 05:18:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50576 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbZDPJSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 05:18:23 -0400
Message-ID: <49E6F7D6.8010107@redhat.com>
Date: Thu, 16 Apr 2009 12:18:14 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] deal with interrupt shadow state for emulated instruction
References: <1239653210-10422-1-git-send-email-glommer@redhat.com> <49E45894.7090700@redhat.com> <49E4B4D4.1020903@zytor.com> <49E4B654.6060101@redhat.com> <49E4B8E9.7050703@zytor.com>
In-Reply-To: <49E4B8E9.7050703@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Avi Kivity wrote:
>   
>> Why do we care?  The guest can only harm itself, and if it wants to
>> disable interrupts, it would be a lot easier for it to run a plain 'cli'.
>>
>> I guess it would be a problem if we emulated 'mov ss' for ordinary
>> userspace or vm86 mode, but we don't.
>>
>>     
>
> Well, the answer is that mov ss is an unprivileged instruction.
>
>   

We don't emulate guest user mode.

Well, if guest userspace can convince its kernel to give it access to 
some memory mapped I/O register, I guess it can execute repeated 'mov 
ss, mmio' and starve the guest kernel.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

