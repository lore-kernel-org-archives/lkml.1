Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbYC0GeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbYC0GeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 02:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbYC0Gd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 02:33:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48275
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753647AbYC0Gd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 02:33:57 -0400
Date: Wed, 26 Mar 2008 23:33:54 -0700 (PDT)
Message-Id: <20080326.233354.102892522.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: m.kozlowski@tuxland.pl, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: sparc64 BUG: using smp_processor_id() in preemptible
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080326202502.f06938bd.akpm@linux-foundation.org>
References: <20080326.041626.224135350.davem@davemloft.net>
	<20080326.042516.261621639.davem@davemloft.net>
	<20080326202502.f06938bd.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 26 Mar 2008 20:25:02 -0700

> On Wed, 26 Mar 2008 04:25:16 -0700 (PDT) David Miller <davem@davemloft.net> wrote:
> 
> >  	preempt_disable();
> >  
> > +	mp = &__get_cpu_var(mmu_gathers);
> 
> that's an open-coded get_cpu_var().
> 
> fwiw.  Which isn't much, IMO.  Sometimes it's nice to see things open-coded.

Good point, I might restructure that to use {get,put}_cpu_var().
