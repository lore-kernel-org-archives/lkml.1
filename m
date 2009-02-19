Return-Path: <linux-kernel-owner+w=401wt.eu-S1755092AbZBTDXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbZBTDXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 22:23:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbZBTDWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 22:22:53 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54563
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750740AbZBTDWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 22:22:52 -0500
Date: Thu, 19 Feb 2009 14:36:22 -0800 (PST)
Message-Id: <20090219.143622.74141834.davem@davemloft.net>
To: nickpiggin@yahoo.com.au
Cc: tj@kernel.org, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
Subject: Re: [PATCH 01/10] vmalloc: call flush_cache_vunmap() from
 unmap_kernel_range()
From: David Miller <davem@davemloft.net>
In-Reply-To: <200902192306.28360.nickpiggin@yahoo.com.au>
References: <1234958676-27618-1-git-send-email-tj@kernel.org>
	<1234958676-27618-2-git-send-email-tj@kernel.org>
	<200902192306.28360.nickpiggin@yahoo.com.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <nickpiggin@yahoo.com.au>
Date: Thu, 19 Feb 2009 23:06:27 +1100

> On Wednesday 18 February 2009 23:04:27 Tejun Heo wrote:
> > Impact: proper vcache flush on unmap_kernel_range()
> >
> > flush_cache_vunmap() should be called before pages are unmapped.  Add
> > a call to it in unmap_kernel_range().
> >
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> Shouldn't this go as a fix to mainline and even .stable?
> 
> Otherwise:
> Acked-by: Nick Piggin <npiggin@suse.de>

Agreed, this is -stable material:

Acked-by: David S. Miller <davem@davemloft.net>
