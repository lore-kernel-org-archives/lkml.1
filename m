Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbZCRKV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbZCRKV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 06:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754741AbZCRKVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 06:21:16 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:54631 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587AbZCRKVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 06:21:15 -0400
Message-ID: <49C0CB15.1090308@in.ibm.com>
Date: Wed, 18 Mar 2009 15:51:09 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-s390@vger.kernel.org
Subject: Next March 18: defconfig build break on s390
References: <20090318173830.7ea03dfb.sfr@canb.auug.org.au>
In-Reply-To: <20090318173830.7ea03dfb.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's next defconfig build on s390 fails with

In file included from arch/s390/include/asm/tlb.h:29,
from arch/s390/mm/init.c:36:
arch/s390/include/asm/tlbflush.h: In function __tlb_flush_full:
arch/s390/include/asm/tlbflush.h:54: error: incompatible type for argument 2 of cpumask_equal

In file included from arch/s390/kernel/smp.c:46:
arch/s390/include/asm/tlbflush.h: In function __tlb_flush_full:
arch/s390/include/asm/tlbflush.h:54: error: incompatible type for argument 2 of cpumask_equal

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

