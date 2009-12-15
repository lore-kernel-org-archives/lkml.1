Return-Path: <linux-kernel-owner+w=401wt.eu-S1760044AbZLOLwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044AbZLOLwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 06:52:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757677AbZLOLwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 06:52:08 -0500
Received: from sh.osrg.net ([192.16.179.4]:42069 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519AbZLOLwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 06:52:03 -0500
Date: Tue, 15 Dec 2009 20:50:53 +0900
To: yinghai@kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, rdreier@cisco.com,
       linux-kernel@vger.kernel.org, cl@linux-foundation.org
Subject: Re: bisected crash due to "x86: Move swiotlb initialization before
 dma32_free_bootmem"
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4B277235.4010308@kernel.org>
References: <20091215105650.GA13214@elte.hu>
	<20091215201039V.fujita.tomonori@lab.ntt.co.jp>
	<4B277235.4010308@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091215205034Y.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 15 Dec 2009 20:50:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009 03:25:41 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> FUJITA Tomonori wrote:
> > On Tue, 15 Dec 2009 11:56:50 +0100
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> >> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> >>
> >>> There are a few people who hit this. How many people use a box with over 
> >>> 256GB memory?
> >>>
> >>> And you can work around this with "dma32_size" kernel boot option.
> >> Well, since the kernel has not crashed before this change there's really just 
> >> two options as per upstream kernel regression policy: either we fix it or we 
> >> revert it.
> > 
> > As I wrote, here is a patch that can be applied to cleanly to the git
> > head:
> > 
> > http://www.kernel.org/pub/linux/kernel/people/tomo/misc/0001-x86-two-stage-swiotlb-initialization.patch
> > 
> > It fixes the problem. Yinghai, can you test it? It should work but
> > it's good to confirm it.
> 
> i tested already, it works.

Great, thanks a lot!

I've just sent the patch.


> > I simply wanted to say that it's not a bug that breaks lots of boxes
> > or leads to something serious like data corruption (no need to say
> > something like "revert it now!"). It's also worth investigating why it
> > breaks, I think.
> 
> will look at it later

Thanks. If it's due to huge memory, I try to work on it.
