Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbYGGG5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbYGGG5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 02:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbYGGG5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 02:57:07 -0400
Received: from po-out-1718.google.com ([72.14.252.154]:39061 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbYGGG5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 02:57:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tU4CyNVwcnwWuDa6nXLyY9OJ9KGd9kTpb7MVAssyACneO/9HJ/7fyAfz4wX49C7Gyn
         656+kJXYnGbYc/m0iIxst6MCDJclEshSKTftXnX2bAn3i1e9YzSXzU67iK8o7sYo6Rsn
         Ka6j7KmEypQNcakaift6UjnHhV7HcW67YUkd0=
Message-ID: <86802c440807062357r64385178sa8e24b13dd95ac5f@mail.gmail.com>
Date: Sun, 6 Jul 2008 23:57:05 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [Bug #10872] x86_64 boot hang when CONFIG_NUMA=n
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>
In-Reply-To: <20080707063218.GC23583@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
	 <uBi7uNfg81L.A.XLC.s0LcIB@albercik>
	 <20080706111750.a6d77e81.randy.dunlap@oracle.com>
	 <alpine.LFD.1.10.0807061133230.3016@woody.linux-foundation.org>
	 <20080707063218.GC23583@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 6, 2008 at 11:32 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> > This still happens with 2.6.26-rc9.  Using CONFIG_NUMA=y boots OK.
>>
>> Ok, then it wasn't the nr_zones thing.
>>
>> Since it seems to be repeatable for you, can you bisect it?
>
> one guess would be:
>
> | commit e8ee6f0ae5cd860e8e6c02807edfa3c1fa01bcb5
> | Author: Yinghai Lu <yhlu.kernel@gmail.com>
> | Date:   Sun Apr 13 01:41:58 2008 -0700
> |
> |     x86: work around io allocation overlap of HT links
>
> but ... since CONFIG_NUMA makes it work, i'm not sure about that.
>
> Randy, could you post the full CONFIG_NUMA bootlog as well, does it show
> any difference in resource allocations?
>
l looked resource allocations in that bootlog.

all my AMD test servers work well with Randy's config (!NUMA)
( Linus tree or tip tree)

YH
