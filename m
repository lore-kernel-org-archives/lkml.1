Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbYHVEp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbYHVEp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 00:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbYHVEpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 00:45:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:56018 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbYHVEpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 00:45:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hYaefu8jRWUoLFP7iABdpXOYSE/VCV6vgTGuabthRCP/yhJ69tfxk64W+rYCojIWxS
         TdkJqDaoZJm1iZbAQ7vV5Yn4rSQg/JjnGDE89elvDKY1R1QaOzypBVrADLafhqguZfdi
         zoU8O5QEORTJYVbJPBIX/9QPDR3xDJdgYNotE=
Message-ID: <86802c440808212145s79b364edle030c29d130b6e3d@mail.gmail.com>
Date: Thu, 21 Aug 2008 21:45:44 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [Bug 11388] New: 2.6.27-rc3 warns about MTRR range; only 3 of 16gb of memory is usable
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       j_kernel@hoblitt.com
In-Reply-To: <20080822035144.GC30284@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <bug-11388-27@http.bugzilla.kernel.org/>
	 <20080820180405.7f164450.akpm@linux-foundation.org>
	 <86802c440808201820w6c684a10y2f1d0f70a344a14a@mail.gmail.com>
	 <86802c440808201849k6665c395x5a5b871eca55addd@mail.gmail.com>
	 <20080821114430.GC30667@elte.hu> <20080821115642.GA2270@elte.hu>
	 <86802c440808210839u452d9440kd7d12694db515411@mail.gmail.com>
	 <20080822035144.GC30284@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 8:51 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> On Thu, Aug 21, 2008 at 4:56 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > * Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> >>
>> >> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> >>
>> >> > [PATCH] x86_64: printout msr
>> >>
>> >> looks rather useful - added it to tip/x86/debug.
>> >
>> > fails to build with the attached config:
>> >
>> > arch/x86/kernel/cpu/common_64.c: In function 'print_cpu_msr':
>> > arch/x86/kernel/cpu/common_64.c:456: error: implicit declaration of function 'rdmsrl_amd_safe'
>> > arch/x86/kernel/cpu/common_64.c: In function 'print_cpu_info':
>> > arch/x86/kernel/cpu/common_64.c:486: error: 'struct cpuinfo_x86' has no member named 'cpu_index'
>> >
>> > i realize that this wasnt sent for inclusion, but i think it would make
>> > sense to tidy it up and integrate it.
>>
>> that was one tool to verify if BIOS does right thing about some special bits.
>>
>> it seems it doesn't compile when xen etc is enable in config.
>
> yeah - but would be nice to fix it, as it's a useful diagnostic patch.
> If people have similar problems in the future they can boot their distro
> kernels with show_mtrr=x to get a MTRR dump.
>

will look at it.

YH
