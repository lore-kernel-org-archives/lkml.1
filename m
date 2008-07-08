Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbYGHAY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbYGHAY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 20:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754721AbYGHAYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 20:24:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:3011 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393AbYGHAYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 20:24:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RxGngnyJGeCI7Kd7s+JUnzDW3TXSiBEBptxBwWpchXcwjel7znb89kJ1rKIL+s/ZA1
         5dPxeY9qnNxUFuvkggSIPSpRHriJJVwKP2y6ME/p2D9bicljmFJ9m8L1v0gBge6CA/ZB
         mwyCx+dZByVN9JtLlgAiIBbDaKi0ebYw17pz4=
Message-ID: <86802c440807071724i1a186879h479460ada28e1b26@mail.gmail.com>
Date: Mon, 7 Jul 2008 17:24:16 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [Bug #10872] x86_64 boot hang when CONFIG_NUMA=n
Cc: lkml <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>
In-Reply-To: <20080707154042.04bb492e.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
	 <uBi7uNfg81L.A.XLC.s0LcIB@albercik>
	 <20080706111750.a6d77e81.randy.dunlap@oracle.com>
	 <alpine.LFD.1.10.0807061133230.3016@woody.linux-foundation.org>
	 <20080707063218.GC23583@elte.hu>
	 <20080707113917.6fda3f7d.randy.dunlap@oracle.com>
	 <20080707154042.04bb492e.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2008 at 3:40 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Mon, 7 Jul 2008 11:39:17 -0700 Randy Dunlap wrote:
>
>> On Mon, 7 Jul 2008 08:32:18 +0200 Ingo Molnar wrote:
>>
>> >
>> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>> >
>> > > > This still happens with 2.6.26-rc9.  Using CONFIG_NUMA=y boots OK.
>> > >
>> > > Ok, then it wasn't the nr_zones thing.
>> > >
>> > > Since it seems to be repeatable for you, can you bisect it?
>> >
>> > one guess would be:
>> >
>> > | commit e8ee6f0ae5cd860e8e6c02807edfa3c1fa01bcb5
>> > | Author: Yinghai Lu <yhlu.kernel@gmail.com>
>> > | Date:   Sun Apr 13 01:41:58 2008 -0700
>> > |
>> > |     x86: work around io allocation overlap of HT links
>> >
>> > but ... since CONFIG_NUMA makes it work, i'm not sure about that.
>> >
>> > Randy, could you post the full CONFIG_NUMA bootlog as well, does it show
>> > any difference in resource allocations?
>>
>> Good and bad boot logs are attached.  There are several differences, but I don't
>> see any that are significant.
>>
>> I've started bisecting with:
>>
>> $ git bisect start
>> $ git bisect bad v2.6.26-rc1
>> $ git bisect good v2.6.25
>>
>> That's only about 1.29M lines of changes.
>
> git bisect and normal rebooting did not find a problem.
>
> I'll repeat this using kexec to boot the new kernel and see if that
> locates any issues... since I normally use kexec to load/test new kernels
> and that was how the failure occurred (occurs).
>

same NON-NUMA kernel kexec NON-NUMA kernel?

or other kernel kexex it?

YH
