Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbYFTHVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbYFTHVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 03:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbYFTHUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 03:20:55 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:39189 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbYFTHUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 03:20:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=U+XYMgi6M7fmZolpztnS37cYFANfktpu0y/AMlJuCvXUMDqvHYLFtcG8Up6Dwu8ZWA
         5Xkj82qKOlzl1kVW2jCmcW4nvRsSI4fzSz9D4lrX6LF4qWeYZodpJX8qisNKmj0vqETS
         DkSgtA3PECLKTIucUXDAV9/0Vy8iZmGoro+SE=
Message-ID: <86802c440806200020x3d204c8ct305711a6cbd9618c@mail.gmail.com>
Date: Fri, 20 Jun 2008 00:20:44 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: update mptable v7
Cc: "Len Brown" <lenb@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080620064750.GB31182@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806011317.38622.yhlu.kernel@gmail.com>
	 <86802c440806181532g348864e1u3d067f8366046a7f@mail.gmail.com>
	 <alpine.LFD.1.10.0806182031060.3074@localhost.localdomain>
	 <86802c440806181749g2faf1892iea693717ea919631@mail.gmail.com>
	 <m1mylim4e6.fsf@frodo.ebiederm.org>
	 <alpine.LFD.1.10.0806190121210.3613@localhost.localdomain>
	 <m1abhilyl0.fsf@frodo.ebiederm.org>
	 <86802c440806190031q17049054md2a790224d30d29@mail.gmail.com>
	 <alpine.LFD.1.10.0806191412100.3040@localhost.localdomain>
	 <20080620064750.GB31182@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2008 at 11:47 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Len Brown <lenb@kernel.org> wrote:
>
>> > the patch did print out the old and updated mptable.
>> >
>> > and that feature is enabled via "update_mptable" command line.
>> >
>> >
>> > also it is useful for kexec from acpi kernel to no acpi kernel on MB
>> > with nvidia chipset with AMI BIOS.
>> > becuase irq routing is different from mptable and acpi.
>> >
>> > amd8111/amd8131 chipset with AMI bios has same irq routing from
>> > mptable and acpi.
>> >
>> > Phonix BIOS, has one setup option APIC/PIC, and if select APIC, then
>> > irq routing from mptable and acpi is the same with
>> > nvidia chipset.
>>
>> So you know this can't NEVER be reliable, yet you continue to push for
>> upstream changes that carry risk for all systems that DO work.
>
> Yinghai: Len has a point, could you please double-check that no
> potentially risky code runs by default anywhere, without a specific boot
> option? update_mptable is supposed to achieve that, but lets make sure
> it does its job.

will double check that, and would consider to add
CONFIG_UPDATE_MPTABLE to make it not be built in be default.

YH
