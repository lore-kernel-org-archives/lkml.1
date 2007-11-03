Return-Path: <linux-kernel-owner+w=401wt.eu-S1760161AbXKCDkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760161AbXKCDkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 23:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbXKCDkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 23:40:13 -0400
Received: from ozlabs.org ([203.10.76.45]:53358 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088AbXKCDkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 23:40:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18219.60812.260878.12141@cargo.ozlabs.ibm.com>
Date: Sat, 3 Nov 2007 14:39:56 +1100
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ralf Baechle <ralf@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jay Estabrook <jay.estabrook@hp.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH] Use i8253.c lock for PC speaker on MIPS, too.
In-Reply-To: <alpine.LFD.0.999.0711021940010.3342@woody.linux-foundation.org>
References: <20071102161650.GA28459@linux-mips.org>
	<20071102172606.GA29513@linux-mips.org>
	<alpine.LFD.0.999.0711021940010.3342@woody.linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds writes:

> and wouldn't it be nice if we just changed it to
> 
> 	#include <asm/i8253.h>
> 
> and got rid of one totally unnecessary stupid arch difference?

Looks fine to me.  I'll do a patch for powerpc & ppc.

Paul.
