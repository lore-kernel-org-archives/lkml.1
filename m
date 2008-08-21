Return-Path: <linux-kernel-owner+w=401wt.eu-S1759462AbYHUPkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462AbYHUPkQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 11:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbYHUPkC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 11:40:02 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:65034 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbYHUPkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 11:40:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Dzr2YxvfluWeMDEaV4JC47zrDqZJKxu43v+d9bthU9teZI8mPn9zb9uB7VWmF7YPKU
         CBSWhU2hdu5oxwL1osYZ3eCpLG6MVXq8wKYsGO6Wk75L0zOfvUw1KJV+3qJNj5ERUKP3
         /F+VxiWdv7CHdnCcCviTEUS6mn3PE/uJEQmKE=
Message-ID: <86802c440808210839u452d9440kd7d12694db515411@mail.gmail.com>
Date: Thu, 21 Aug 2008 08:39:59 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [Bug 11388] New: 2.6.27-rc3 warns about MTRR range; only 3 of 16gb of memory is usable
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       j_kernel@hoblitt.com
In-Reply-To: <20080821115642.GA2270@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <bug-11388-27@http.bugzilla.kernel.org/>
	 <20080820180405.7f164450.akpm@linux-foundation.org>
	 <86802c440808201820w6c684a10y2f1d0f70a344a14a@mail.gmail.com>
	 <86802c440808201849k6665c395x5a5b871eca55addd@mail.gmail.com>
	 <20080821114430.GC30667@elte.hu> <20080821115642.GA2270@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 4:56 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>>
>> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>
>> > [PATCH] x86_64: printout msr
>>
>> looks rather useful - added it to tip/x86/debug.
>
> fails to build with the attached config:
>
> arch/x86/kernel/cpu/common_64.c: In function 'print_cpu_msr':
> arch/x86/kernel/cpu/common_64.c:456: error: implicit declaration of function 'rdmsrl_amd_safe'
> arch/x86/kernel/cpu/common_64.c: In function 'print_cpu_info':
> arch/x86/kernel/cpu/common_64.c:486: error: 'struct cpuinfo_x86' has no member named 'cpu_index'
>
> i realize that this wasnt sent for inclusion, but i think it would make
> sense to tidy it up and integrate it.

that was one tool to verify if BIOS does right thing about some special bits.

it seems it doesn't compile when xen etc is enable in config.

YH
