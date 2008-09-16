Return-Path: <linux-kernel-owner+w=401wt.eu-S1757181AbYIPShq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181AbYIPShq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 14:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754733AbYIPShi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 14:37:38 -0400
Received: from rn-out-0910.google.com ([64.233.170.186]:59006 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402AbYIPShh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 14:37:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oT3/CHRRvnNkPmuRfDWqxspKwCTBvrtw7dxGsu+r6GnV7J3P9eQeFSY7XzY1fvyfu3
         L2olJE7i31I9L7aTH6mdZpgv8IAHxU6/EgPv+BwvZLdHgOZ0rNHCL/4VU0uvw52WrjbL
         dPa+dHim+4Pr3cTa28m2QPbBbr7Lb7Zpo6R2M=
Message-ID: <86802c440809161137r4264190bxe76f7e6b90235087@mail.gmail.com>
Date: Tue, 16 Sep 2008 11:37:36 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] introduce boot_printk()
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, jbaron <jbaron@redhat.com>
In-Reply-To: <48CFFB72.70203@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221465916-30889-1-git-send-email-yhlu.kernel@gmail.com>
	 <86802c440809151034ycd6442me679792880b03320@mail.gmail.com>
	 <1221575196.6943.24.camel@lappy.programming.kicks-ass.net>
	 <48CFD97C.6080002@zytor.com>
	 <86802c440809161045q2f6d80f1yb6e79f32c6e0c303@mail.gmail.com>
	 <48CFF281.7010101@zytor.com>
	 <86802c440809161110q1fc3d66vedcaa32dea2b2233@mail.gmail.com>
	 <48CFF7DF.6010404@zytor.com>
	 <86802c440809161124h1245380ch9a3ba588e6ff737@mail.gmail.com>
	 <48CFFB72.70203@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 11:31 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>>
>> On Tue, Sep 16, 2008 at 11:15 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>
>>> Yinghai Lu wrote:
>>>>
>>>> you still can use
>>>> pci_printk(v, KERN_PCI KERN_DEBUG "...\n");
>>>>
>>>> if vprintk is expanded to handle KERN_PCI and other tags...
>>>> or even you could use
>>>> pci_printk(v, KERN_ACPI KERN_DEBUG "...\n");
>>>>
>>> And the point of this, other than sheer verbosity?
>>
>> let every file or componet of subsystem could control the print out
>> via loglevel=pci_any_name:7
>>
>
> pci_printk(v, KERN_ACPI KERN_DEBUG "...\n");
> ^^^^          ^^^^^^^^^
>
> Not only do you have duplication, here, but inconsistency...

how about
pci_printk(v, KERN_DEBUG "...\n");

will put
<pci> <7> ...\n
in dmesg bug,

and let vprintk get rid of <pci> like <7>

is that what you want?

YH
