Return-Path: <linux-kernel-owner+w=401wt.eu-S1758192AbZA2WGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192AbZA2WGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 17:06:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbZA2WF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 17:05:59 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:61684 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbZA2WF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 17:05:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=kTFDhNZwlOxuDNVYHwpy0nL+O4YBFgrC0NRhws2Tmxpt1kRaFsD6lKiS73RB067rRG
         HJ3O9NX4oADBaxWhclSH5s5o2TePqAcLxMVUrhiHkoRSyNHcnLP85N/h3jS48I6SykKF
         JgL8fBpMp1xMq+7wWvp9hVF/ZdDTEqfIeoBWE=
MIME-Version: 1.0
In-Reply-To: <74ae4f6a0901291402j19575c87g418bee66ba9f3519@mail.gmail.com>
References: <74ae4f6a0901291402j19575c87g418bee66ba9f3519@mail.gmail.com>
Date: Thu, 29 Jan 2009 14:05:57 -0800
Message-ID: <74ae4f6a0901291405o6b615399vaa033abfbeac3a06@mail.gmail.com>
Subject: Re: x86_64 IOAPIC
From: SUJIT V <sujit.linux@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot to mention that we are not using the irqbalance utility.

So which part of the kernel io_apic code is doing the irq balancing
which we see in /proc/interrupt.

Thanks


On Thu, Jan 29, 2009 at 2:02 PM, SUJIT V <sujit.linux@gmail.com> wrote:
> Hi,
>    We have a IBM Qauadcore 8 CPU system running x86_64 linux 2.6.23.
> We were doing some performance test. (disk & network).
> The eth0 IRQ is pinned to CPU0.  The aacraid interrupt has not been
> assigned any smp affinity.
>
> On the system we see in (/proc/interrupts) that when the eth0
> interrupt rate is high, the aacraid interrupt counter for CPU0 does
> not increase as much compared to aacraid interrupts handled by other
> CPUs .
> This shows that IOAPIC is doing some load balancing.
>
> I wanted to check the code which is doing this load balancing. I
> checked the file arch/x86_64/kernel/io_apic.c. I could not find any
> irq balancing stuff out there.
> I went through some archived discussions about the x86_64 ioapic irq
> balancing. Most of the discussions were about using irqbalance
> utility.
>
>
> Could some one point me to the relevant piece of io_apic code ?
>
>
> Thanks
>
