Return-Path: <linux-kernel-owner+w=401wt.eu-S1757042AbYBEKX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbYBEKX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 05:23:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbYBEKXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 05:23:52 -0500
Received: from gir.skynet.ie ([193.1.99.77]:35220 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753566AbYBEKXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 05:23:51 -0500
Date: Tue, 5 Feb 2008 10:23:48 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Gerhard Pircher <gerhard_pircher@gmx.net>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: Commit for mm/page_alloc.c breaks boot process on my machine
Message-ID: <20080205102347.GA11949@csn.ul.ie>
References: <20080201184254.174020@gmx.net> <20080201191119.GI18688@csn.ul.ie> <20080201200518.174050@gmx.net> <20080201202518.GJ18688@csn.ul.ie> <20080201210656.174030@gmx.net> <20080204104232.GB29484@csn.ul.ie> <1202169686.7079.17.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1202169686.7079.17.camel@pasglop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (05/02/08 11:01), Benjamin Herrenschmidt didst pronounce:
> 
> > 
> > It's a virtual address so it depends on the value of CONFIG_KERNEL_START
> > as to whether this is a user program address or not.
> 
> Shouldn't it be PAGE_OFFSET ? I mean, CONFIG_KERNEL_START should work
> on powerpc, but still...
> 

mel@arnold:~/git/linux-2.6$ grep PAGE_OFFSET include/asm-ppc/page.h
#define PAGE_OFFSET     CONFIG_KERNEL_START

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
