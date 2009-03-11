Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465AbZCKMQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbZCKMQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 08:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbZCKMQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 08:16:42 -0400
Received: from mail-bw0-f178.google.com ([209.85.218.178]:45098 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359AbZCKMQl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 08:16:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ls0nvu4t5uWYw1Z37QjiuY3oaQTEx+ckXrSL3SJXh+nL4zx4yRK9tt/+vHcdEakXtT
         lvARsrhxXMDpTuIvcmRG8UWJYpgPb/ilHP2oQAr5nbuQVtbi4sNEb3h5+CuvXdCHr67p
         Mu3+x0qY1mdvoaRDaAAPTKrhjG6Mp1kv1In64=
MIME-Version: 1.0
In-Reply-To: <20090311121123.GA7656@localhost>
References: <e2dc2c680903110341g6c9644b8j87ce3b364807e37f@mail.gmail.com>
	 <20090311114353.GA759@localhost>
	 <e2dc2c680903110451m3cfa35d9s7a9fd942bcee39eb@mail.gmail.com>
	 <20090311121123.GA7656@localhost>
Date: Wed, 11 Mar 2009 13:16:38 +0100
Message-ID: <e2dc2c680903110516v2c66d4a4h6a422cffceb12e2@mail.gmail.com>
Subject: Re: Memory usage per memory zone
From: jack marrow <jackmarrow2@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/11 Wu Fengguang <fengguang.wu@intel.com>:
> On Wed, Mar 11, 2009 at 01:51:32PM +0200, jack marrow wrote:
>> 2009/3/11 Wu Fengguang <fengguang.wu@intel.com>:
>> > Hi jack,
>> >
>> > On Wed, Mar 11, 2009 at 11:41:43AM +0100, jack marrow wrote:
>> >> Hello,
>> >>
>> >> I have a box where the oom-killer is killing processes due to running
>> >> out of memory in zone_normal. I can see using slabtop that the inode
>> >
>> > How do you know that the memory pressure on zone normal stand out alone?
>>
>> For the normal zone only, I see "all_unreclaimable: yes" and 3 megs of free ram:
>>
>> kernel: Normal free:2576kB min:3728kB low:7456kB high:11184kB
>> active:1304kB inactive:128kB present:901120kB pages_scanned:168951
>> all_unreclaimable? yes
>
> It's normal behavior.  Linux kernel tries hard to utilize most of
> the free memory for caching files :)

With all_unreclaimable = yes is normal?

>
>> >> caches are using up lots of memory and guess this is the problem, so
>> >> have cleared them using an echo to drop_caches.
>> >
>> > It would better be backed by concrete numbers...
>> >
>> >>
>> >> I would quite like to not guess though - is it possible to use slabtop
>> >> (or any other way) to view ram usage per zone so I can pick out the
>> >> culprit?
>> >
>> > /proc/zoneinfo and /proc/vmstat do have some per-zone numbers.
>> > Some of them deal with slabs.
>>
>> Thanks, I'll read up on how to interpret these.
>>
>> Do you recommend these two files for tracking down memory usage per
>> process per zone?
>
> No, the two interfaces provide system wide counters.  We have the well
> known tools "ps" and "top" for per-process numbers, hehe.

ps and top do not have per-zone numbers. How do I get those?

>
> Thanks,
> Fengguang
