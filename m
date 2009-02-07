Return-Path: <linux-kernel-owner+w=401wt.eu-S1755068AbZBGH7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbZBGH7h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 02:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbZBGH73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 02:59:29 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:5844 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbZBGH72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 02:59:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=V6kdFOKMxvfGRs4Y1xuR47gagg4x1AdvfW0BFVCAlXOVJip2dO63n0sycD0otpp73F
         X3GcjpEtb7OH0YW1Cq/rbOSJXC6VAWlwudUjExEHJNVkUc9PuujralQYBpx/NjTBEwfV
         jxfEcgEcq8HFX44mJBzUat40R6PaVak34CntE=
MIME-Version: 1.0
In-Reply-To: <200902071820.50212.rusty@rustcorp.com.au>
References: <200902071809.39175.rusty@rustcorp.com.au>
	 <498D3C01.1050307@kernel.org>
	 <200902071820.50212.rusty@rustcorp.com.au>
Date: Fri, 6 Feb 2009 23:59:27 -0800
X-Google-Sender-Auth: e07f53692935da44
Message-ID: <86802c440902062359g611b7748n4bbf5e3bbf8023cb@mail.gmail.com>
Subject: Re: [PATCH 2/3] cpumask: fix powernow-k8: partial revert of 
	2fdf66b491ac706657946442789ec644cc317e1a
From: Yinghai Lu <yinghai@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 6, 2009 at 11:50 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Saturday 07 February 2009 18:15:05 Yinghai Lu wrote:
>> Rusty Russell wrote:
>> > Impact: fix powernow-k8 when acpi=off (or other error).
>> >
>> > There was a spurious change introduced into powernow-k8 in this patch:
>> > the cause if that we try to "restore" the cpus_allowed we never saved.
>> >
>> > See lkml "[PATCH] x86/powernow: fix cpus_allowed brokage when
>> > acpi=off" from Yinghai for the bug report.
>> >
>>
>> and
>>
>> [PATCH] x86/powernow: dont emit warning when acpi=off
>
> To be clear, is this for 2.6.29, or can wait for .30?
should be .30. just trival...
> The three I sent are needed for 2.6.29 I think.
sure about this one.

YH
