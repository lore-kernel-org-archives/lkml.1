Return-Path: <linux-kernel-owner+w=401wt.eu-S1755822AbYIDTW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbYIDTW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 15:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYIDTWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 15:22:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:14591 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbYIDTWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 15:22:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LYu+A/ruQqVzxqHV6vKhzn23gj8ARTvNzwbfhAvuwnK16CCrY9YshtF4wWZDXWfD0n
         HB03SESnVco/HDDV+R5Bx4EfB66SrSsI/gcns6uBkYS3OqafwfO6Hg9d0HwJlbmWzCDb
         B5c23EwXQTtXV8Br1FEXZhRogPejdeQbZs7yA=
Message-ID: <86802c440809041222q244e1adaj16b80f1590053bcf@mail.gmail.com>
Date: Thu, 4 Sep 2008 12:22:17 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v4 - fix v7
Cc: "Ingo Molnar" <mingo@elte.hu>, tglx@linutronix.de, hpa@zytor.com,
       jbarnes@virtuousgeek.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080904121627.bc182da7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220254284-29532-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080904190457.GB24990@elte.hu>
	 <20080904121627.bc182da7.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2008 at 12:16 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 4 Sep 2008 21:04:57 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
>
>> +             printk(KERN_DEBUG "    __reserve_region_with_split: (%s) [%llx, %llx], res: (%s) [%llx, %llx]\n",
>> +                      conflict->name, conflict->start, conflict->end,
>> +                      name, start, end);
>
> start and end have type resource_size_t.  Such types CANNOT be printed
> unless cast to a known type.
>
> Because there is a %s following an incorrect %lld, the above code will
> crash the machine.

should just remove those lines.

YH
