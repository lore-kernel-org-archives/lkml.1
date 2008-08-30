Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbYH3S54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbYH3S54 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 14:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbYH3S5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 14:57:49 -0400
Received: from flusers.ccur.com ([12.192.68.2]:57271 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753569AbYH3S5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 14:57:48 -0400
Date: Sat, 30 Aug 2008 14:57:30 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] shrink printk timestamp field
Message-ID: <20080830185730.GA12660@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20080827151759.GA10678@tsunami.ccur.com> <20080829163540.634e86d9.akpm@linux-foundation.org> <20080830143808.GA10821@tsunami.ccur.com> <20080830101618.b6c2e1ab.akpm@linux-foundation.org> <c384c5ea0808301047g7b3658can77b41e5906d306b6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c384c5ea0808301047g7b3658can77b41e5906d306b6@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 01:47:06PM -0400, Leon Woestenberg wrote:
> On Sat, Aug 30, 2008 at 7:16 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> On Sat, 30 Aug 2008 10:38:08 -0400 Joe Korty <joe.korty@ccur.com> wrote:
>>> On Fri, Aug 29, 2008 at 07:35:40PM -0400, Andrew Morton wrote:
>>>> On Wed, 27 Aug 2008 11:17:59 -0400 Joe Korty <joe.korty@ccur.com> wrote:
>>>>
>>>>> Shrink the printk timestamp field.
>>>
>>> I was looking at it from the point of view of finding out where the
>>> boot process was too slow.  For that millisecs is enough.  I am not
>>> sure where knowing printk output to the microsec would be useful for
>>> solving anything.
>>
>> Of course it's useful.  If you're working on performance or latency in
>> a disk, network or USB driver, microsecond resolution is about right.
>>
> I second this. If we have timestamps enables, let it be useful for all
> current uses. The 3 digits extra are very cheap useful information in
> that area (without resorting to more elaborate methods like the
> recently merged latency tracer).
> 
> Rather than cut 3 digits off, maybe fix some of the too-wide prints
> would solve the posters issue better.
> 
> Can we please have this patch non-committed or reverted?

I have no objection...
Joe
