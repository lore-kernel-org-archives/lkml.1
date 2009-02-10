Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbZBJKaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbZBJKaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 05:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbZBJKa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 05:30:26 -0500
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:59195 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbZBJKaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 05:30:25 -0500
Message-ID: <4991573C.8000609@in.ibm.com>
Date: Tue, 10 Feb 2009 16:00:20 +0530
From: "Sachin P. Sant" <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-s390@vger.kernel.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, Mel Gorman <mel@csn.ul.ie>
Subject: Next Feb 10 : build/break arch/s390kernel.irq.o 
References: <20090210194121.80256b72.sfr@canb.auug.org.au>
In-Reply-To: <20090210194121.80256b72.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

randconfig build on s390 fails with

  CC      arch/s390/kernel/irq.o
arch/s390/kernel/irq.c:99: error: redefinition of init_irq_proc
include/linux/interrupt.h:475: error: previous definition of init_irq_proc was here
make[1]: *** [arch/s390/kernel/irq.o] Error 1
make: *** [arch/s390/kernel] Error 2

CONFIG_PROC_FS is not set. Probably introduced by commit
("Declare init_irq_proc before we use it.")

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

