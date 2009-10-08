Return-Path: <linux-kernel-owner+w=401wt.eu-S1759088AbZJHR5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759088AbZJHR5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 13:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758765AbZJHR5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 13:57:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:38174 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757702AbZJHR5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 13:57:54 -0400
Subject: Re: [rfc][patch] store-free path walking
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>
In-Reply-To: <20091008133003.GM9228@kernel.dk>
References: <20091006064919.GB30316@wotan.suse.de>
	 <20091006101414.GM5216@kernel.dk> <20091006122623.GE30316@wotan.suse.de>
	 <20091006124941.GS5216@kernel.dk> <20091007085849.GN30316@wotan.suse.de>
	 <alpine.LFD.2.01.0910070742260.3432@localhost.localdomain>
	 <20091008123622.GA30316@wotan.suse.de> <20091008125746.GL9228@kernel.dk>
	 <20091008132200.GB30316@wotan.suse.de>  <20091008133003.GM9228@kernel.dk>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 08 Oct 2009 20:00:45 +0200
Message-Id: <1255024846.26976.329.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-08 at 15:30 +0200, Jens Axboe wrote:
> 
> IIRC, there was a bug with thread accounting very recently. Why would it
> not hit -rc3 alone, though? Does look fishy, though.

That was caused by: 
  def0a9b2573e00ab0b486cb5382625203ab4c4a6 sched_clock: Make it NMI safe

And was fixed by:  
  152f9d0710a62708710161bce1b29fa8292c8c11 sched_clock: Fix
atomicity/continuity bug by using cmpxchg64()

Which is in -rc3
