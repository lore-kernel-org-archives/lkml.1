Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbYIYVDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbYIYVDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 17:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbYIYVC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 17:02:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:64130 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbYIYVCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 17:02:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LVXG6XMXoiTvVRMGW1yOhhflog3DxHkmjMyFvthgzJcO4yj420TLnJ+Q8YvuQw2eyp
         9Mu3nUgYFBI1fbo6x7bD1F/p5kOYFx3ENwXs3i3epIGVaGPdXI5ZYl/Em00YHQA44rq+
         XgW9NVk37pel1uz7OWj5obQxobmPslTsKGoJA=
Message-ID: <19f34abd0809251402v13b926a1o2236ddb9e7517a65@mail.gmail.com>
Date: Thu, 25 Sep 2008 23:02:54 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: v2.6.27-rc7: x86: #GP on panic?
Cc: "Ingo Molnar" <mingo@elte.hu>, x86@kernel.org,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <48DBF964.7070106@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0809241209l3a69d607v153549ee43e085e9@mail.gmail.com>
	 <20080925080417.GB27048@elte.hu> <48DB5186.8060502@zytor.com>
	 <19f34abd0809250707i18ded94aib177c884d4d6a3bd@mail.gmail.com>
	 <19f34abd0809250820q2df15e93u43374b7317e2f7be@mail.gmail.com>
	 <19f34abd0809251346r62cff1ck4730260f17e643b3@mail.gmail.com>
	 <48DBF964.7070106@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 10:49 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Seems like an external interrupt happened and was delivered after the sti?
>>
>> Hm. I guess it smells like a qemu bug since it's rather easily
>> reproducible here and sounds strange that nobody else saw it. Is qemu
>> 0.9.1.
>>
>
> Yes, but there shouldn't be any external interrupts that could turn into  a
> divide error.  It really smells like a Qemu problem -- possibly even a Qemu
> miscompile -- to me.
>
> Does it reproduce in KVM?

I have no computer that can do KVM, sorry :-(

Stack trace contains IO_APIC functions, so it seems that maybe the
emulated IOAPIC is trying to (erroneously) deliver an int 0 (for some
reason)? But I don't know, that's just speculation which can be done
better by others, so I will stop now :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
