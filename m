Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbYBDOCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbYBDOCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 09:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638AbYBDOCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 09:02:04 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:18458 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbYBDOCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 09:02:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QzUm3RCeRkhV9hZbH5tlay92LcaTsvY7+j5m1+WjJLRA5k/RVZkbOn/MhEUo0SK0Q3CcvCE/UCirSiV+cGvfIoCOBEdGaXpJfCEVHornWgyOqZBPNe1OnSgfmghAzlXA0q2vnUKTttCiIwnaLgI0V57K/Ghi6KBEY34Cq/11KLI=
Message-ID: <b6a2187b0802040601s76222435t306aef2059cbbb2b@mail.gmail.com>
Date: Mon, 4 Feb 2008 22:01:59 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Commit f06e4ec breaks vmware
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       petr@vandrovec.name
In-Reply-To: <20080204115144.GA17850@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802020120150.18790@fbirervta.pbzchgretzou.qr>
	 <20080204115144.GA17850@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 4, 2008 7:51 PM, Ingo Molnar <mingo@elte.hu> wrote:

> > sad to say, but f06e4ec... breaks booting the kernel in vmware
> > commit f06e4ec1c15691b0cfd2397ae32214fa36c90d71

I had the same problem. But I bisect down to a earlier commit.
Reverting this patch, and I can boot up using vmware.

commit 8d947344c47a40626730bb80d136d8daac9f2060
Author: Glauber de Oliveira Costa <gcosta@redhat.com>
Date:   Wed Jan 30 13:31:12 2008 +0100

    x86: change write_idt_entry signature


> could you send us the /proc/cpuinfo data of the guest CPU?

Here's my guest's /proc/cpuinfo

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 14
model name      : Intel(R) Core(TM) Duo CPU      L2500  @ 1.83GHz
stepping        : 8
cpu MHz         : 1828.645
cache size      : 2048 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss constant_tsc up
arch_perfmon pebs bts pni
bogomips        : 3546.54
clflush size    : 64


> if latest -git still fails, does the patch below solve the problem?

Doesn't seem to work for me.


Thanks,
Jeff.
