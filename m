Return-Path: <linux-kernel-owner+w=401wt.eu-S1761601AbYAaJfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761601AbYAaJfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 04:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbYAaJfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 04:35:05 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:36849 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbYAaJfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 04:35:01 -0500
Subject: Re: x86 arch updates also broke s390
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Adrian Bunk <bunk@stusta.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Nick Piggin <npiggin@suse.de>, heiko.carstens@de.ibm.com,
       linux390@de.ibm.com
In-Reply-To: <20080131003310.GW29368@does.not.exist>
References: <20080130011550.GA31853@elte.hu>
	 <20080131003310.GW29368@does.not.exist>
Content-Type: text/plain
Organization: IBM Corporation
Date: Thu, 31 Jan 2008 10:34:54 +0100
Message-Id: <1201772094.18221.32.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-31 at 02:33 +0200, Adrian Bunk wrote:
> <--  snip  -->
> 
> ...
>   CC      arch/s390/kernel/asm-offsets.s
> In file included from 
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/s390/kernel/asm-offsets.c:7:
> /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/sched.h: In
> function 'spin_needbreak':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/sched.h:1931:
> error: implicit declaration of function '__raw_spin_is_contended'
> make[2]: *** [arch/s390/kernel/asm-offsets.s] Error 1
> 
> <--  snip  -->

Defining GENERIC_LOCKBREAK in arch/s390/Kconfig takes care of it. I'll
cook up a patch and queue it in git390.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


