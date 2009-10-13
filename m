Return-Path: <linux-kernel-owner+w=401wt.eu-S933896AbZJMKeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933896AbZJMKeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 06:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933879AbZJMKeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 06:34:18 -0400
Received: from mtagate6.de.ibm.com ([195.212.17.166]:44617 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933885AbZJMKeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 06:34:16 -0400
Date: Tue, 13 Oct 2009 12:33:35 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, heiko.carstens@de.ibm.com,
       linux-s390@vger.kernel.org
Subject: Re: [BUILD-FAILURE] next-20091013 - s390x build breaks at mm/fault
 with !CONFIG_S390_EXEC_PROTECT
Message-ID: <20091013123335.6d6820b3@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <20091013100648.GA7542@linux.vnet.ibm.com>
References: <20091013162312.8b93998b.sfr@canb.auug.org.au>
	<20091013100648.GA7542@linux.vnet.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009 15:36:48 +0530
Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> 	next-20091013 randconfig build breaks on s390, with
> CONFIG_S390_EXEC_PROTECT=y
> 
> arch/s390/mm/fault.c: In function 'signal_return':
> arch/s390/mm/fault.c:221: error: implicit declaration of function 'is_compat_task'
> make[1]: *** [arch/s390/mm/fault.o] Error 1
> 
> is_compat_task is defined at asm/compat.h, including the 
> header, helps

I'll merge that info "[PATCH] fault handler performance optimization" if you
don't mind.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

