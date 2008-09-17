Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbYIQQZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbYIQQZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbYIQQZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:25:14 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:35654 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbYIQQZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:25:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oNiIC9X1K3o6zWwfZvE9lPDd6DsbPF6ZaoyPvYgEQaT4/8vU5OLxHy9pgalFBMDfVh
         UmauAYFoEchPHW0UaEXIsY1UMR3EkHOU1QjkfMmDlZ8wu+ck/H5nQbn7atWXNhutanbF
         UGb6LyMUJJP/9hm+s/D+98zkrC2Kb92V5u73A=
Message-ID: <86802c440809170925i1eac326ciadf4a1d18b86ec10@mail.gmail.com>
Date: Wed, 17 Sep 2008 09:25:11 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Robert Richter" <robert.richter@amd.com>
Subject: Re: [PATCH 3/6] pci: using printk(KERN_PCI v3
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080917101129.GC23138@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221640067-24389-1-git-send-email-yhlu.kernel@gmail.com>
	 <1221640067-24389-4-git-send-email-yhlu.kernel@gmail.com>
	 <20080917083506.GA24035@elte.hu>
	 <86802c440809170141s5c206ec9ub1ea077ed923ec20@mail.gmail.com>
	 <20080917101129.GC23138@erda.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 3:11 AM, Robert Richter <robert.richter@amd.com> wrote:
> On 17.09.08 01:41:03, Yinghai Lu wrote:
>> On Wed, Sep 17, 2008 at 1:35 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> >
>> >> -                     printk(KERN_DEBUG "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
>> >> +                     printk(KERN_DEBUG KERN_PCI
>> >> +                              "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
>> >
>> > i think we should aim to make the common usage of this facility as easy
>> > and short as possible. That means that i think the right line is:
>> >
>> > +                       printk(KERN_PCI
>> > +                                "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
>> >
>> > as that is the shortest form. KERN_PCI should imply whatever
>> > common-sense default. It should still make sense to specify KERN_FOO
>> > KERN_PCI, to override that default.
>>
>> vprintk will add default before that like
>> like print(KERN_INFO KERN_PCI ....)
>
> What about a pci_dbg() macro similiar to dev_dbg()? Same could be used
> for ACPI, acpi_dbg().
>

according to different users ...

YH
