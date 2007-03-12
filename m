Return-Path: <linux-kernel-owner+w=401wt.eu-S965026AbXCLEpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965026AbXCLEpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 00:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965114AbXCLEpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 00:45:20 -0400
Received: from mail28.syd.optusnet.com.au ([211.29.133.169]:51419 "EHLO
	mail28.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965026AbXCLEpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 00:45:18 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Vincent Fortier <vincent.fortier1@ec.gc.ca>, ck list <ck@vds.kolivas.org>
Subject: Re: RSDL v0.30 cpu scheduler for ... 2.6.18.8 kernel
Date: Mon, 12 Mar 2007 15:45:06 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <8E8F647D7835334B985D069AE964A4F7028FE62A@ECQCMTLMAIL1.quebec.int.ec.gc.ca> <200703120417.57761.vincent.fortier1@ec.gc.ca>
In-Reply-To: <200703120417.57761.vincent.fortier1@ec.gc.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703121545.06379.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2007 19:17, Vincent Fortier wrote:
> > There are updated patches for 2.6.20, 2.6.20.2, 2.6.21-rc3 and
> > 2.6.21-rc3-mm2 to bring RSDL up to version 0.30 for download here:
> >
> > Full patches:
> >
> > http://ck.kolivas.org/patches/staircase-deadline/2.6.20-sched-rsdl-0.30.p
> >at ch
> > http://ck.kolivas.org/patches/staircase-deadline/2.6.20.2-rsdl-0.30.patch
> > http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-sched-rsdl-0.
> >30 .patch
> > http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-mm2-rsdl-0.30
> >.p atch
> >
> > incrementals:
> >
> > http://ck.kolivas.org/patches/staircase-deadline/2.6.20/2.6.20.2-rsdl-0.2
> >9- 0.30.patch
> > http://ck.kolivas.org/patches/staircase-deadline/2.6.20.2/2.6.20.2-rsdl-0
> >.2 9-0.30.patch
> > http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3/2.6.21-rc3-rs
> >dl -0.29-0.30.patch
> > http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-mm2/2.6.21-rc
> >3- mm2-rsdl-0.29-0.30.patch

> And here are the backported RSDL 0.30 patches in case any of you would
> still be running an older 2.6.18.8 kernel ...

Thanks, your efforts are appreciated as it would take me quite a while to do a 
variety of backports that people are already requesting.

> Just for info, verison 0.30 seems around 2 seconds faster than 0.26-0.29
> versions at boot time.  I used to have around 2-3 seconds of difference
> between a vanilla and a rsdl patched kernel.  Now it looks more like 5
> seconds faster!  Wow.. nice work CK!
>
> 2.6.18.8 vanilla kernel:
> [   68.514248] ACPI: Power Button (CM) [PWRB]

> 2.6.18.8-rsdl-0.30:
> [   63.739337] ACPI: Power Button (CM) [PWRB]

Indeed there's almost 5 seconds difference there. To be honest, the boot time 
speedups are an unexpected bonus, but everyone seems to be reporting them on 
all flavours so perhaps all those timeout related driver setups are 
inadvertently benefiting.

> - vin

Thanks

-- 
-ck
