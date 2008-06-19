Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbYFSUAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbYFSUAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 16:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750957AbYFSUAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 16:00:38 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:22081 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbYFSUAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 16:00:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=J0FrqP0gsP3EJUwbr72+c7Hne2Bs1fDuhRxf+hjm0ILXDK680Dud1L7OxRVpzUrESI
         NrSbM1j57DHnMb/9ICOd5T1SoyFXJ9GbQ8TAP5UOFUSi1BHbR2cQar//3MHI/P3QJiap
         iogLReUUFqsAfVZZNS14CMrHDIGscRq+An5a0=
Message-ID: <86802c440806191300l1a840140q9cbef4f42b10f741@mail.gmail.com>
Date: Thu, 19 Jun 2008 13:00:36 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: make 64bit identify_cpu use cpu_dev
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Dave Jones" <davej@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080619090323.GA1575@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806180215.53755.yhlu.kernel@gmail.com>
	 <20080618141759.GG11501@elte.hu> <20080619090323.GA1575@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2008 at 2:03 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>
>> > may need to move some functions to common.c later
>> >
>> > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>
>> applied to tip/x86/cpu, thanks Yinghai.
>
> -tip testing found a boot failure on 64-bit, the bootup just hangs early
> during bootup. I bisected it down to this patch and reverting the patch
> solves the lockup.
>
> Here is the config that triggers it:
>
>  http://redhat.com/~mingo/misc/config-Thu_Jun_19_10_11_15_CEST_2008.bad

can not duplicate that here.

can you send me the boot log on your system?

YH
