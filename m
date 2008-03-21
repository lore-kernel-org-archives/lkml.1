Return-Path: <linux-kernel-owner+w=401wt.eu-S1761458AbYCUUJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761458AbYCUUJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 16:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691AbYCUUJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 16:09:10 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:54432 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463AbYCUUJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 16:09:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mL1dzUGYO8V1SkYM4bKQ5A8M1cCCX7lBTNYFpAyK2CFLsQwTL3JdIS6jmrGjTpUj+vTaQ5JGDdIc9dGM3NTMA5+otQYNOBNC+wgNffP5XYy3LG6YCT6ynjvJ7AICoj2e5ILlXDVYaHPSSMxapOH7JVFI40bLmawr2SLpXYRRG60=
Message-ID: <86802c440803211309x501137ccq5eefdeab6423dd4@mail.gmail.com>
Date: Fri, 21 Mar 2008 13:09:06 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86_64: early memtest to find bad ram
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <47E4137C.3010203@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803202358.33722.yhlu.kernel@gmail.com>
	 <20080321120313.GD25225@elte.hu> <47E3B335.3020501@zytor.com>
	 <86802c440803211208v40088eb1qe3f03977b220078@mail.gmail.com>
	 <47E4137C.3010203@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 12:58 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Yinghai Lu wrote:
>  > On Fri, Mar 21, 2008 at 6:08 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>  >> Ingo Molnar wrote:
>  >>  >
>  >>  > very nice patch! I always thought that this was the proper way to do
>  >>  > memtest - and we could in fact also do something like this after SMP
>  >>  > bringup, and hit the memory bus via multiple CPUs. [that will need a
>  >>  > different enumeration though than e820 maps]
>  >>  >
>  >>  > one structural observation: please make this unified functionality, so
>  >>  > that 32-bit kernels can make use of it too.
>  >>  >
>  >>
>  >>  Indeed.  Of course, it would also be nice if distros shipped
>  >>  bootloader-invoked prekernel test software, like memtest86+, by default.
>  >
>  > the current memtest86 is running in 32 bit mode, and only support 64G ram.
>  >
>  > I tried to expand that a bit, to support 1024g, but it only works on
>  > some machine.
>  > could be stack provide is not big enough?
>  >
>
>  Wonder how hard it would be to make it run 64 bits...

1. in 32 bit test less than 4g in 32 bit mode
2. switch to 64 bit, set page table under 4g to cover all ram...

YH
