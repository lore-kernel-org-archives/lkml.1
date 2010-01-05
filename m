Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821Ab0AEFUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab0AEFUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 00:20:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713Ab0AEFUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 00:20:42 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:33544 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab0AEFUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 00:20:41 -0500
To: Venkappa Mala <Venkappa.Mala@lntinfotech.com>
Cc: "rmk+lkml\@arm.linux.org.uk" <rmk+lkml@arm.linux.org.uk>,
       <linux-kernel@vger.kernel.org>,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: Linux kernel crash dumps for ARM
References: <EB1A7C66AD0C92419BFFC785A947865A09EA8C9129@BLRINMSMBX01.bglrodc.lntinfotech.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 04 Jan 2010 21:20:23 -0800
In-Reply-To: <EB1A7C66AD0C92419BFFC785A947865A09EA8C9129@BLRINMSMBX01.bglrodc.lntinfotech.com> (Venkappa Mala's message of "Tue\, 5 Jan 2010 10\:19\:31 +0530")
Message-ID: <m17hrx9lgo.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Venkappa Mala <Venkappa.Mala@lntinfotech.com> writes:

I have added the kexec list and corrected the lkml addresses.
In principle it should not be too hard to use kexec on panic
support on arm.

I don't do any arm development so I don't have a clue what the status
of the support is on arm.

> Hi,
>
> With respect to "Linux kernel crash dumps for ARM", i have some doubts which are described as below.
>
> If the machine has crashed so badly that you cannot enter commands or
> the disk is not available then you have three options :-
>
> (1) Hand copy the text from the screen
>
> (2) capture crash logs using Minicom.
>
> (3) save the crash data to a floppy disk or video rom or a swap partition or reserved memory.
>
> In the above three options, 1 & 2 are known and works as well.
>
> Regarding 3 option,
> ----------------------------
> i would like to support for ARM11.
>
> As far as i know, the supported linux kernel crash dumps are
> "lkcd, netdump,diskdump, mini kernel dump and kdump/kexec".
> These are supported for x86 and PowerPC architectures with some constrains.
>
> i have some queries with respect to ARM supports, these are
>
> 1.) kexec is supported in latest kernels
>         example: 2.6.29 kernel
>         File: arch/arm/kernel/machine_kexec.c
>
>     - is this working well or is there any constraints?
>
> 2) As per kexec supports, kexec-tool is required and this allows you to load directly
>    to a new kernel from the currently running one
>
>     As from my side, i am not able to find arm implementation support in kexec-tools/crash sources.
>
>    - is kexce-tool supported for ARM or not?
>
> 3) In lkcd, netdump,diskdump, mini kernel dump and kdump/kexec tools,
>
>    - which is the best choice for ARM or are there any best crash dump tool for ARM?
>
> Please clarify my queries.
>
> Best Regards,
> Venkappa

Eric

