Return-Path: <linux-kernel-owner+w=401wt.eu-S1762742AbXGFCGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762742AbXGFCGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 22:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759590AbXGFCGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 22:06:40 -0400
Received: from hu-out-0506.google.com ([72.14.214.227]:29153 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759587AbXGFCGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 22:06:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CbOvnsIx9as8SgpMNerB5H+wkF1n1Tu7JOEPoSiVuSH0TZmGUiAeArul7rnizEnVEBWKu0Tkbm3zNdWHEcCL8VrYk3rZUGCr1PkB47Czs4LPxKvF2NFO6hkqMJFHRK20f+22fIBAsraB9UMjMmE0hcejRv9jlnakkJ8mKr/rBNM=
Message-ID: <91b13c310707051906l94be14u795a058bd838ef3d@mail.gmail.com>
Date: Fri, 6 Jul 2007 10:06:37 +0800
From: "rae l" <crquan@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: Does the kernel HPET support has problems or the hwclock from util-linux?
Cc: rtc-linux@googlegroups.com, "Luca Tettamanti" <kronos.it@gmail.com>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <200707032302.52612.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707032302.52612.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/3/07, Luca Tettamanti <kronos.it@gmail.com> wrote:
> rae l <crquan@gmail.com> ha scritto:
> > from this address, I know util-linux-2.12r is the latest:
> > http://www.kernel.org/pub/linux/utils/util-linux/util-linux-2.12r.lsm
> >
> > My Dell OptiPlex 320 has 4 HPET timers and no RTC, so the execution of
> > hwclock has errors:
> >
> > gektop@tux ~ $ /sbin/hwclock --show
> > select() to /dev/rtc to wait for clock tick timed out
> > gektop@tux ~ $ /sbin/hwclock --version
> > hwclock from util-linux-2.12r
>
> I think that the problem is that HPET and the CMOS RTC (list in CC)
> share the same interrupt line.
> I suppose that you should enable CONFIG_HPET_RTC_IRQ (my hardware has
> the same "feature"); in this way /dev/rtc correcly reports that it
> cannot deliver the interrupt (when HPET is enabled) and hwclock uses
> direct ISA access.
I searched the CONFIG_HPET_RTC_IRQ, it's conflict with
HPET_EMULATE_RTC, that I've enabled.
so while HPET_RTC_IRQ is the good way, EMULATE_RTC is a bad way.

>
> Luca
> --
> Windows NT crashed.
> I'm the Blue Screen of Death.
> No one hears your screams.
>


-- 
Denis Cheng
Linux Application Developer
