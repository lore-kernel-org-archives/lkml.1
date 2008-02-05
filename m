Return-Path: <linux-kernel-owner+w=401wt.eu-S1760601AbYBEUu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760601AbYBEUu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbYBEUur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:50:47 -0500
Received: from gate.crashing.org ([63.228.1.57]:54640 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746AbYBEUuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:50:46 -0500
Subject: Re: Commit for mm/page_alloc.c breaks boot process on my machine
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Mel Gorman <mel@csn.ul.ie>
Cc: Gerhard Pircher <gerhard_pircher@gmx.net>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080205102347.GA11949@csn.ul.ie>
References: <20080201184254.174020@gmx.net>
	 <20080201191119.GI18688@csn.ul.ie> <20080201200518.174050@gmx.net>
	 <20080201202518.GJ18688@csn.ul.ie> <20080201210656.174030@gmx.net>
	 <20080204104232.GB29484@csn.ul.ie> <1202169686.7079.17.camel@pasglop>
	 <20080205102347.GA11949@csn.ul.ie>
Content-Type: text/plain
Date: Wed, 06 Feb 2008 07:50:20 +1100
Message-Id: <1202244620.7079.70.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-05 at 10:23 +0000, Mel Gorman wrote:
> On (05/02/08 11:01), Benjamin Herrenschmidt didst pronounce:
> > 
> > > 
> > > It's a virtual address so it depends on the value of CONFIG_KERNEL_START
> > > as to whether this is a user program address or not.
> > 
> > Shouldn't it be PAGE_OFFSET ? I mean, CONFIG_KERNEL_START should work
> > on powerpc, but still...
> > 
> 
> mel@arnold:~/git/linux-2.6$ grep PAGE_OFFSET include/asm-ppc/page.h
> #define PAGE_OFFSET     CONFIG_KERNEL_START

On powerpc sure.... but it's still dodgy I think.

Ben.


