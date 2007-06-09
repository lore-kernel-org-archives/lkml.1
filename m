Return-Path: <linux-kernel-owner+w=401wt.eu-S1757405AbXFIQtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbXFIQtf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 12:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771AbXFIQt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 12:49:29 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:62902 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976AbXFIQt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 12:49:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ld6a1m/qabQosSq4+o/u6Cu4aScnpwn1Kfc7bKrPnpiWCSdyFx6mHRBDuzNdxEV+uESTUJxB60IH9AqTBBEBo+HeeLvjY9pIiffvvR1FcWTlJe92CU/jzLuSP5El1TYMufA1ICLqylXVfmUwVdgb35t9NwtKDq8MFUxrzmigvvk=
Message-ID: <55f6199c0706090949u7a6dff18h94f6375a2151629b@mail.gmail.com>
Date: Sat, 9 Jun 2007 12:49:26 -0400
From: Disconnect <dc.disconnect@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: system clock slow on Athlon AMD64 since 2.6.21
In-Reply-To: <200706091453.l59ErWtB026333@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706091453.l59ErWtB026333@harpo.it.uu.se>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/9/07, Mikael Pettersson <mikpe@it.uu.se> wrote:
> According to your system description it seems that you have a
> Targa Visionary laptop with a VIA chipset and a Mobile Athlon64.
> If so, then you probably have the same problem I reported some time
> ago: see <http://marc.info/?l=linux-kernel&m=117681226421346&w=2>
> and the followup messages. The conclusion was that the chipset's
> ACPI PM timer slows down when the CPU is in C2.
>
> The workaround is to boot with processor.max_cstate=1.
>

I was seeing the same problem on a Ferrari 3200 (with ubuntu kernels)
but more recent kernels (2.6.21.3-ck2-swsusp2) don't ever seem to
enter C2 at all - according to powertop (1.5) its always in C0. (And
yes, this solved the clock problem at the cost of power use.)

I can provide any additional details that might help, and I'm in a
decent position to test things right now.

processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 12
model name      : Mobile AMD Athlon 64 Processor 2800+
stepping        : 0
cpu MHz         : 800.000
cache size      : 512 KB
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext lm
3dnowext 3dnow
bogomips        : 1605.13
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp
