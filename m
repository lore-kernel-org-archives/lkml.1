Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbZJAPVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbZJAPVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 11:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754324AbZJAPVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 11:21:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbZJAPVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 11:21:39 -0400
Message-ID: <4AC4C8F2.5050708@redhat.com>
Date: Thu, 01 Oct 2009 17:21:22 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v2] core, x86: Add user return notifiers
References: <4AB3CDEC.5050902@zytor.com> <1253342422-13811-1-git-send-email-avi@redhat.com> <4AB8980D.5070803@redhat.com> <20090922143223.GA31702@elte.hu> <4AB8EAF2.1030204@zytor.com>
In-Reply-To: <4AB8EAF2.1030204@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2009 06:19 PM, H. Peter Anvin wrote:
> Ingo Molnar wrote:
>> * Avi Kivity <avi@redhat.com> wrote:
>>
>>> On 09/19/2009 09:40 AM, Avi Kivity wrote:
>>>> Add a general per-cpu notifier that is called whenever the kernel is
>>>> about to return to userspace.  The notifier uses a thread_info flag
>>>> and existing checks, so there is no impact on user return or context
>>>> switch fast paths.
>>> Ingo/Peter?
>>
>> Would be nice to convert some existing open-coded 
>> return-to-user-space logic to this facility. One such candidate would 
>> be lockdep_sys_exit?
>>
>>     Ingo
>
> Sorry, limited bandwidth due to LinuxCon, but I like the concept, and 
> the previous (partial) patch was really clean.  I agree with Ingo that 
> arch support so we can use this as a general facility would be nice, 
> but I don't consider that as a prerequisite for merging.

Re-ping?

If accepted, please merge just the core patch and I will carry all of 
them in parallel.  Once tip is merged I'll drop my copy of the first patch.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

