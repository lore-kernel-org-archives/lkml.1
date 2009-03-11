Return-Path: <linux-kernel-owner+w=401wt.eu-S1755794AbZCKLvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbZCKLvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 07:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbZCKLvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 07:51:37 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:58222 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbZCKLvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 07:51:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BGpf34N2HUIZqu79E34b05QI0gbDKKh+dx/zB7/yZqcy5CUNhBrFX0aSiC+RpqBxbV
         nf/gHbHIh8crSmccndaP7a1endkTDsOvNlpNtJT6z5e3HVhYeNzRRKxcr53MDcwHfdqp
         pj8m9m5mRAI+kFG8DJHcB0i9xEm5NKGePoqRo=
MIME-Version: 1.0
In-Reply-To: <20090311114353.GA759@localhost>
References: <e2dc2c680903110341g6c9644b8j87ce3b364807e37f@mail.gmail.com>
	 <20090311114353.GA759@localhost>
Date: Wed, 11 Mar 2009 12:51:32 +0100
Message-ID: <e2dc2c680903110451m3cfa35d9s7a9fd942bcee39eb@mail.gmail.com>
Subject: Re: Memory usage per memory zone
From: jack marrow <jackmarrow2@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/11 Wu Fengguang <fengguang.wu@intel.com>:
> Hi jack,
>
> On Wed, Mar 11, 2009 at 11:41:43AM +0100, jack marrow wrote:
>> Hello,
>>
>> I have a box where the oom-killer is killing processes due to running
>> out of memory in zone_normal. I can see using slabtop that the inode
>
> How do you know that the memory pressure on zone normal stand out alone?

For the normal zone only, I see "all_unreclaimable: yes" and 3 megs of free ram:

kernel: Normal free:2576kB min:3728kB low:7456kB high:11184kB
active:1304kB inactive:128kB present:901120kB pages_scanned:168951
all_unreclaimable? yes

>> caches are using up lots of memory and guess this is the problem, so
>> have cleared them using an echo to drop_caches.
>
> It would better be backed by concrete numbers...
>
>>
>> I would quite like to not guess though - is it possible to use slabtop
>> (or any other way) to view ram usage per zone so I can pick out the
>> culprit?
>
> /proc/zoneinfo and /proc/vmstat do have some per-zone numbers.
> Some of them deal with slabs.

Thanks, I'll read up on how to interpret these.

Do you recommend these two files for tracking down memory usage per
process per zone?

Thanks.
