Return-Path: <linux-kernel-owner+w=401wt.eu-S1751089AbZHREMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751089AbZHREMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 00:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750751AbZHREMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 00:12:19 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:51480 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbZHREMS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 00:12:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=b6giavPLrSby6HrCZQJfV4b84rw2fmv3dP+95Ojo1pm5rGq86QHLcpAGkJZMa8mlMl
         /osVai+j226wvAeVJzk/N5ko/mV0ujxeoEK6vOu07MG0675UJS8Po9yb2bZeWa4b+kt9
         EuqTP4SJabJm8mGKLDaiMkyCFwoA7mD6UQtlI=
MIME-Version: 1.0
In-Reply-To: <20090817203047.6cff48fb.akpm@linux-foundation.org>
References: <a8e1da0908172025s728c62ber37acb6c2073f7794@mail.gmail.com>
	 <20090817203047.6cff48fb.akpm@linux-foundation.org>
Date: Tue, 18 Aug 2009 12:12:18 +0800
Message-ID: <a8e1da0908172112kca79a1en7042fc1738ad1336@mail.gmail.com>
Subject: Re: -mm hang while shutdown with printk_delay
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 11:30 AM, Andrew
Morton<akpm@linux-foundation.org> wrote:
> On Tue, 18 Aug 2009 11:25:22 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:
>
>> Hi,
>>
>> Test with printk_delay=200,
>>
>> /sbin/halt -p
>>
>> kernel hang after following message:
>>
>> Disabling non-boot CPUs
>>
>> There's no such problem with 2.6.31-rc6
>
> umm, OK.  But -mm contains six patches:
>
> printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch
> printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
> printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix-2.patch
> printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.patch
> printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
> printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
>
> from yourself.  Are they the cause?
>

Actually I tested 2.6.31-rc6 with the above six patches applied,
there's no such problem.

-- 
Regards
dave
