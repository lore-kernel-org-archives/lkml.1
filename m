Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbYIPTY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbYIPTY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 15:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753802AbYIPTYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 15:24:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:8122 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbYIPTYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 15:24:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ndwRCwN59K5BPMJb/iuMromtZd/1Yp38OwnLXNRkJQgGqu6xbyQpve/ueVyAYMRSGB
         UN37dqNq4Bhl2Yviaxsdk2q5Fyt79mmtB06wG5ql/fCuFq51anbn9/6RgorFXK8t9bAM
         i3BCfJuo5rqJp2nYha4WKXN+g/axRVBi/msJA=
Message-ID: <86802c440809161224s249846a8n15cb1f7eb98d7c05@mail.gmail.com>
Date: Tue, 16 Sep 2008 12:24:45 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] introduce boot_printk()
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, jbaron <jbaron@redhat.com>
In-Reply-To: <48D000B0.8070108@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221465916-30889-1-git-send-email-yhlu.kernel@gmail.com>
	 <48CFD97C.6080002@zytor.com>
	 <86802c440809161045q2f6d80f1yb6e79f32c6e0c303@mail.gmail.com>
	 <48CFF281.7010101@zytor.com>
	 <86802c440809161110q1fc3d66vedcaa32dea2b2233@mail.gmail.com>
	 <48CFF7DF.6010404@zytor.com>
	 <86802c440809161124h1245380ch9a3ba588e6ff737@mail.gmail.com>
	 <48CFFB72.70203@zytor.com>
	 <86802c440809161137r4264190bxe76f7e6b90235087@mail.gmail.com>
	 <48D000B0.8070108@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 11:53 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>>>
>>> Not only do you have duplication, here, but inconsistency...
>>
>> how about
>> pci_printk(v, KERN_DEBUG "...\n");
>>
>> will put
>> <pci> <7> ...\n
>> in dmesg bug,
>>
>> and let vprintk get rid of <pci> like <7>
>>
>> is that what you want?
>>
>
> First of all, what is the "v" here, and why not just have
> printk(KERN_PCI KERN_DEBUG "...\n");
>
> ... and we can do #define PCI_DEBUG KERN_PCI KERN_DEBUG even.
>
> We do have a need for special macros when we're doing device-specific
> prefixes, of course.  If that is what your "v" is meant to be, then there
> was an implicit topic shift in the discussion thread.

will try.

YH
