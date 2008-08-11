Return-Path: <linux-kernel-owner+w=401wt.eu-S1752911AbYHKKzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbYHKKzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 06:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbYHKKzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 06:55:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48037 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbYHKKzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 06:55:13 -0400
To: Zhao Yakui <yakui.zhao@intel.com>
Cc: S K <nospamnoham@gmail.com>, Thomas Renninger <trenn@suse.de>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: cpufreq doesn't seem to work in Intel Q9300
From: Andi Kleen <andi@firstfloor.org>
References: <514e099a0808030300u140a0ae7m92a2e7294f39f7b7@mail.gmail.com>
	<200808081430.43012.trenn@suse.de>
	<aff5deaf0808081123s1fbe6a5cn7847e9cb053c1f5a@mail.gmail.com>
	<200808092059.47863.trenn@suse.de>
	<514e099a0808100128u303207clcb22292db2f0cc59@mail.gmail.com>
	<1218418431.6671.52.camel@yakui_zhao.sh.intel.com>
	<514e099a0808102144n241c8e9ak255bded0a80744f1@mail.gmail.com>
	<1218432270.6671.75.camel@yakui_zhao.sh.intel.com>
Date: Mon, 11 Aug 2008 12:55:11 +0200
In-Reply-To: <1218432270.6671.75.camel@yakui_zhao.sh.intel.com> (Zhao Yakui's message of "Mon, 11 Aug 2008 13:24:30 +0800")
Message-ID: <874p5r3jow.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhao Yakui <yakui.zhao@intel.com> writes:

> On Sun, 2008-08-10 at 21:44 -0700, S K wrote:
>> >> So I'm guessing this is a kernel bug.
>> > >From the attached acpidump it seems that there is no definition of
>> > _PCT,_PSS, _PPC. So acpi_cpufreq driver can't be used on your machine.
>> > This is a BIOS issue.
>> 
>> Yakui, Did you actually check if the above was true?
> Yes. There is no definition of _PSS,_PCT,_PPC in DSDT table, which are
> required by acpi_cpufreq driver.At the same time there is no extra SSDT
> table. 

It sounds like the BIOS just doesn't support frequency scaling. 
Perhaps it's disabled in the BIOS setup. Or the system doesn't
support it at all. 

If he can't find an option to enable it there he'll have to update it
and if there is no update he's out of luck.

I don't think Linux should be blamed for it.

>
>> >
>> > But it is very strange that cpufreq scaling can work on Windows XP.
>> > Will you please try the P4 clock cpufreq driver and see whether the
>> > scaling can work ? In fact P4 clock cpufreq driver is already replaced
>> > by acpi_cpufreq driver for the latest cpu.
>> > Anyway please try p4 clock cpufreq driver.
>> 
>> What is the name of the driver? I'm not able to find any such driver
>> in Fedora 9 installed modules. There is only acpi-cpufreq and powernow-k8.
> The driver is P4-clockmod, which is located in the directory of
> arch/x86/kernel/cpu/cpufreq

Using p4 clockmod doesn't make sense because it doesn't really
safe any power and is often very slow.

-Andi
>> 
