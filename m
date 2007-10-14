Return-Path: <linux-kernel-owner+w=401wt.eu-S1763511AbXJNANX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763511AbXJNANX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 20:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758100AbXJNANK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 20:13:10 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:48464 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbXJNANI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 20:13:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=MVL06d8VDxzHPod6h61YIY4q5UMRyLyKJk1TTpvVTVmyIa6BHyzvijOlpBSVR+MNQkUmFhcd2CM7dOFuqT7RRYj87TFShZenGIa9BkrZx6X5QqEolstCoBHaacy66r0fjbwyyxux5qzg7WwM1pNOGzZFj4eMFbrIcCYssARlBNM=
Message-ID: <47115F09.3090504@gmail.com>
Date: Sun, 14 Oct 2007 02:12:57 +0200
From: Patrizio Bassi <patrizio.bassi@gmail.com>
Reply-To: patrizio.bassi@gmail.com
Organization: patrizio.bassi@gmail.com
User-Agent: Thunderbird 2.0.0.6 (X11/20070802)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-git3 compilation broken, asm headers missing?
References: <4710AD07.70000@gmail.com> <alpine.LFD.0.9999.0710131348310.12017@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0710131348310.12017@localhost.localdomain>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner ha scritto:
> On Sat, 13 Oct 2007, Patrizio Bassi wrote:
>   
>> include/linux/types.h:15:23: error: asm/types.h: No such file or directory
>> In file included from include/linux/prefetch.h:13,
>>                  from include/linux/list.h:8,
>>                  from include/linux/module.h:9,
>>                  from include/linux/crypto.h:21,
>>                  from arch/x86/kernel/asm-offsets_32.c:7,
>>                  from arch/x86/kernel/asm-offsets.c:2:
>>
>> full log attached.
>>     
>
> That's a stale include/asm symlink. Can you save your .config file and do 
>
> make mrproper
>
> please and check if it's solved.
>
> Thanks,
>
> 	tglx
>
>
>   
seems ok now

Thanks!

--
Patrizio Bassi
www.patriziobassi.it
