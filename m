Return-Path: <linux-kernel-owner+w=401wt.eu-S933336AbXCEX7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933336AbXCEX7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 18:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933339AbXCEX7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 18:59:33 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:52738 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933336AbXCEX7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 18:59:33 -0500
Message-ID: <45ECAEDC.1090009@cosmosbay.com>
Date: Tue, 06 Mar 2007 00:59:24 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: David Brown <dmlb2000@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PAGE_SIZE Availability Inconsistency
References: <9c21eeae0703051555x1884fd7cse7968a71ec04eb27@mail.gmail.com>
In-Reply-To: <9c21eeae0703051555x1884fd7cse7968a71ec04eb27@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Tue, 06 Mar 2007 00:59:31 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brown a écrit :
> I was rtfc'ing the code one day and noticed somethings about the
> PAGE_SIZE define that is kinda inconsistent around its relative
> location to the __KERNEL__ define.
> 
> On some architectures the PAGE_SIZE is outside the __KERNEL__ define
> (i386 and x86_64) and on others its inside the define (ia64 and
> powerpc).  I was wondering if this is because the powerpc and ia64
> architectures have dynamic page sizes so that's why they can't export
> PAGE_SIZE outside __KERNEL__.
> 
> I'm kinda wondering how I'm supposed to write portable user-space code
> if I want to use the PAGE_SIZE define on different architectures.

The real question is : why do you need PAGE_SIZE from user-space code ?

If it's for mmap() use, you should use getpagesize()

