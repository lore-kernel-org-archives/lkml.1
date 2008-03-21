Return-Path: <linux-kernel-owner+w=401wt.eu-S1759452AbYCUVzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759452AbYCUVzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 17:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757107AbYCUVzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 17:55:24 -0400
Received: from www.tglx.de ([62.245.132.106]:39674 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756852AbYCUVzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 17:55:23 -0400
Date: Fri, 21 Mar 2008 22:54:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Yinghai Lu <yhlu.kernel@gmail.com>, andi@firstfloor.org, ak@suse.de,
       mingo@elte.hu, clameter@sgi.com, linux-kernel@vger.kernel.org,
       y-goto@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH] mm: fix boundary checking in free_bootmem_core
In-Reply-To: <20080321124404.f9d74052.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0803212252570.3781@apollo.tec.linutronix.de>
References: <86802c440803111801m20349386l58a108cec13eb5ee@mail.gmail.com> <86802c440803121811i262b21bdrfb07df52fd27aaae@mail.gmail.com> <20080312182240.db32c858.akpm@linux-foundation.org> <200803132259.47063.ak@suse.de> <86802c440803131522t3d038d39gbe8eb0d38ddcb634@mail.gmail.com>
 <87iqzp5xfv.fsf@basil.nowhere.org> <86802c440803140944p302b300fy7515fb758221932b@mail.gmail.com> <20080314165336.GS2522@one.firstfloor.org> <86802c440803141036m4a508a91o2cf6706157231429@mail.gmail.com> <20080321124404.f9d74052.akpm@linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, Andrew Morton wrote:
> 
> So Ingo has now merged some x86 patches which apparently had a dependency
> upon this patch: "otherwise free_bootmem_node in dma32_free could do sth
> bad.".
> 
> I had this patch on hold awaiting conclusive feedback from Andi.  It looks
> like it needs to be merged asap and any remaining problems should be
> addressed separately.

I'm too tired to decode all the dependencies and interactions right
now. I will look into that tomorrow morning when my brain works again.

Thanks,

	tglx
