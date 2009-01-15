Return-Path: <linux-kernel-owner+w=401wt.eu-S1761393AbZAOAD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761393AbZAOAD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 19:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760598AbZAOAC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 19:02:58 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:43388 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760123AbZAOAC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 19:02:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=D7QdCsK0X6GffQKNw1DXGDClydmzZbiE2/2075d2+B2aay43wlTlAeBJwjsD3DWhcW
         LaZ96Cj3e/wK6fYlwCKP4JjlPBuTUKSdu15CYNCkoZfN3pw+1ljRmoFOC3tByyJAkbI8
         qBgScFSGR05Tm/jBJfzadQGxuo/WRbloMnOaU=
Message-ID: <496E7D2B.5070606@gmail.com>
Date: Wed, 14 Jan 2009 20:02:51 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: venkatesh.pallipadi@intel.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       Dave Airlie <airlied@redhat.com>
Subject: Re: [patch 0/6] PAT fixes/cleanup following the pfnmap changes
References: <20090110001308.403550000@intel.com> <49689C80.3070905@gmail.com> <20090111020508.GA29153@elte.hu>
In-Reply-To: <20090111020508.GA29153@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Kevin Winchester <kjwinchester@gmail.com> wrote:
> 
>> venkatesh.pallipadi@intel.com wrote:
>>> Individual patch header has descriptions.
>>>
>> $ git am Patches
>> Applying: x86 PAT: change track_pfn_vma_new to take pgprot_t pointer param
>> error: patch failed: mm/memory.c:1604
>> error: mm/memory.c: patch does not apply
>> Patch failed at 0001.
>> When you have resolved this problem run "git am --resolved".
>> If you would prefer to skip this patch, instead run "git am --skip".
>> To restore the original branch and stop patching run "git am --abort".
>>
>> These do not apply for me to latest Linus git, which is the tree where I 
>> experienced the problem.  Is there some way to fuzz them to get them to 
>> apply?
> 
> Could you check tip/master:
> 
>   http://people.redhat.com/mingo/tip.git/README
> 
> do you still get the messages? [ Btw., did you also experience any 3D 
> performance problems that are solved via Venki's fixes in tip/master? ]
> 

(I had noted in another email that tip/master still had the problem.)

However, with latest Linus' git tree (2.6.29-rc1-00224-ga652504),
I no longer see the error messages I had noted before.  Instead I now see:

[  475.132031] agpgart-amd64 0000:00:00.0: AGP 3.0 bridge
[  475.132056] agpgart-amd64 0000:00:00.0: putting AGP V3 device into 8x mode
[  475.132123] pci 0000:01:00.0: putting AGP V3 device into 8x mode
[  475.502856] [drm:radeon_do_init_cp] *ERROR* could not find ioremap agp regions!

Is this related?  I added Dave Airlie to the CC since perhaps he would be the one
to ask about it?

Thanks,

-- 
Kevin Winchester


