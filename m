Return-Path: <linux-kernel-owner+w=401wt.eu-S1758924AbZADR5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924AbZADR5m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 12:57:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbZADR5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 12:57:33 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:1817 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbZADR5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 12:57:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=urovvp7fEZ0ncjo781dE2H/29fW9UrbJ1QCO+EEc2tR30uq2OfFVKpE6PmJBaZFxpY
         adrLcvwO2aHTLw4rAWOfzO5NNsy40g7CtLO0326NcGznGD8I4HWvxA96E2DC4N3TYhi2
         bVMJ8eTTV8DMP3TjZ0CcZ/8Ch9E7pTxFbEKuk=
Message-ID: <3f9a31f40901040957g5a391408u5cda93c4acb66e9d@mail.gmail.com>
Date: Sun, 4 Jan 2009 23:27:31 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH -tip] x86: setup.c fix style problems
Cc: "Jaswinder Singh Rajput" <jaswinder@infradead.org>,
       "x86 maintainers" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090104172114.GA32425@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1231066898.27852.29.camel@jaswinder.satnam>
	 <20090104172114.GA32425@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 4, 2009 at 10:51 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jaswinder Singh Rajput <jaswinder@infradead.org> wrote:
>
>> Impact: cleanup, fix style problems, more readable
>>
>> Fixes style problems:
>> WARNING: Use #include <linux/smp.h> instead of <asm/smp.h>
>> WARNING: Use #include <linux/percpu.h> instead of <asm/percpu.h>
>> WARNING: Use #include <linux/topology.h> instead of <asm/topology.h>
>> WARNING: externs should be avoided in .c files
>> ERROR: code indent should use tabs where possible
>>
>> total: 2 errors, 4 warnings
>
> doesnt build on some configs:
>
>  arch/x86/kernel/setup.c:943: error: implicit declaration of function 'prefill_possible_map'
>

This problem will only arise if CONFIG_SMP is not defined. Then
linux/smp.h will not include asm/smp.h

But why we are keeping non SMP stuff in asm/smp.h, we need to fix this.

JSR
