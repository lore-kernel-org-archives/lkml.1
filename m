Return-Path: <linux-kernel-owner+w=401wt.eu-S1757326AbZJMK6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbZJMK6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 06:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755540AbZJMK6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 06:58:06 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:55305 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbZJMK6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 06:58:04 -0400
Date: Tue, 13 Oct 2009 16:27:20 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, heiko.carstens@de.ibm.com,
       linux-s390@vger.kernel.org
Subject: Re: [BUILD-FAILURE] next-20091013 - s390x build breaks at mm/fault
	with !CONFIG_S390_EXEC_PROTECT
Message-ID: <20091013105720.GB7542@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20091013162312.8b93998b.sfr@canb.auug.org.au> <20091013100648.GA7542@linux.vnet.ibm.com> <20091013123335.6d6820b3@mschwide.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091013123335.6d6820b3@mschwide.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Martin Schwidefsky <schwidefsky@de.ibm.com> [2009-10-13 12:33:35]:

> On Tue, 13 Oct 2009 15:36:48 +0530
> Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
> > 	next-20091013 randconfig build breaks on s390, with
> > CONFIG_S390_EXEC_PROTECT=y
> > 
> > arch/s390/mm/fault.c: In function 'signal_return':
> > arch/s390/mm/fault.c:221: error: implicit declaration of function 'is_compat_task'
> > make[1]: *** [arch/s390/mm/fault.o] Error 1
> > 
> > is_compat_task is defined at asm/compat.h, including the 
> > header, helps
> 
> I'll merge that info "[PATCH] fault handler performance optimization" if you
> don't mind.

Please feel free to merge it.

> 
> -- 
> blue skies,
>    Martin.
> 
> "Reality continues to ruin my life." - Calvin.
> 
			
			Kamalesh
