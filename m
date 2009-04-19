Return-Path: <linux-kernel-owner+w=401wt.eu-S1760310AbZDSI17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760310AbZDSI17 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 04:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757996AbZDSI0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 04:26:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45582 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757942AbZDSI0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 04:26:36 -0400
Message-ID: <49EAE035.6000908@redhat.com>
Date: Sun, 19 Apr 2009 11:26:29 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] deal with interrupt shadow state for emulated instruction
References: <1239653210-10422-1-git-send-email-glommer@redhat.com> <49E45894.7090700@redhat.com> <49E4B4D4.1020903@zytor.com> <49E4B654.6060101@redhat.com> <49E4B8E9.7050703@zytor.com> <49E6F7D6.8010107@redhat.com> <49E7B3EB.6060101@zytor.com>
In-Reply-To: <49E7B3EB.6060101@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Avi Kivity wrote:
>>
>> We don't emulate guest user mode.
>>
>> Well, if guest userspace can convince its kernel to give it access to 
>> some memory mapped I/O register, I guess it can execute repeated 'mov 
>> ss, mmio' and starve the guest kernel.
>>
>
> It doesn't need a MMIO register to do that, even.
>

Can you explain how?

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

