Return-Path: <linux-kernel-owner+w=401wt.eu-S1752003AbZHCGKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbZHCGKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 02:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZHCGKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 02:10:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34208 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbZHCGKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 02:10:19 -0400
Message-ID: <4A767EE4.20702@zytor.com>
Date: Sun, 02 Aug 2009 23:08:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] x86: Add 'percpu_read_stable()' interface for	cacheable
 accesses
References: <200907311813.n6VIDe9S023442@voreg.hos.anvin.org> <alpine.LFD.2.01.0907311218080.3161@localhost.localdomain> <20090731195705.GA12270@elte.hu> <alpine.LFD.2.01.0908011214330.3304@localhost.localdomain> <4A76421E.3040005@kernel.org> <alpine.LFD.2.01.0908021913130.3352@localhost.localdomain> <4A7670E0.4030605@kernel.org> <4A767203.5090802@zytor.com> <4A767325.20604@kernel.org> <20090803060408.GA20762@elte.hu>
In-Reply-To: <20090803060408.GA20762@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Tejun Heo <tj@kernel.org> wrote:
> 
>> H. Peter Anvin wrote:
>>> Tejun Heo wrote:
>>>> Ingo, these patches might as well go through x86 tree.  If you think
>>>> that would be better, please let me know.
>>>>
>>> Makes sense to me.  I'll pull them into x86/percpu.
>> Cool, dropping from my tree then.
> 
> We can delegate the contents of x86/percpu to you (the topic branch 
> contains no patches over mainline right now) - i.e. we can pull 
> those bits from you and they could also be in your tree to keep your 
> testing & integration consistent.
> 

I just pushed out these branches into tip:x86/percpu.  We can zap those 
if there is a tree head you'd rather use.

	-hpa
