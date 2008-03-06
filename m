Return-Path: <linux-kernel-owner+w=401wt.eu-S932810AbYCFT11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810AbYCFT11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 14:27:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757152AbYCFT1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 14:27:05 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:5282 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756871AbYCFT1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 14:27:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pvPIIuItz6NorVpR4jZELjEIIedPJVMo/qLKnGI0VRb5f9WaEnXGjnz5nhNohoQE+wjKX8nlSHO+cUZydpFPY/Nfcq84OKI2ZP4QX5Xf8fEg5SwQsmb3yByyJL4Rm4bUR6WXKEXb9aQzCXKY/AjxXmKt23zobJeLWjSC/h48ysU=
Message-ID: <86802c440803061127s5ca545bch930310a0df6511fc@mail.gmail.com>
Date: Thu, 6 Mar 2008 11:27:02 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: 2.6.25-rc4: crash on boot when SMP enabled
Cc: "Pavel Machek" <pavel@ucw.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20080306131547.GE21359@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080306102927.GA4434@elf.ucw.cz> <20080306131547.GE21359@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2008 at 5:15 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Pavel Machek <pavel@ucw.cz> wrote:
>
>  > Hi!
>  >
>  > On amd 8-core system, I get crash on boot... Last messages:
>  >
>  > Quad-Core AMD Opteron...
>  > Checking TSC Synchronization [CPU#0 -> CPU#3]: passed
>  > BUG: unable to handle kernel paging request at 00...005958
>  > IP: __alloc_pages+0x38
>  > ...
>  > Call trace:
>  > kmem_getpages
>  > cache_grow
>  > ____cache_alloc_node
>  > cpuup_callback
>  > kmem_cache_alloc_node
>  > cpuup_callback
>  > notifier_call_chain
>  > _cpu_up
>
>  could you try latest x86.git:
>
>     http://people.redhat.com/mingo/x86.git/README
>
>  does it fix it? Could be one of the numa fixes that are queued up.

Pavel,

can we have your config and whole bootlog?

YH
