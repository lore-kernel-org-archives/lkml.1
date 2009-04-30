Return-Path: <linux-kernel-owner+w=401wt.eu-S1763842AbZD3QHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763842AbZD3QHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 12:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbZD3QHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 12:07:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45709 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758971AbZD3QHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 12:07:13 -0400
Date: Thu, 30 Apr 2009 18:06:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: unlisted-recipients: no@elvis.elte.hu, To-header@elvis.elte.hu,
       on@elvis.elte.hu, "input <"@elvis.elte.hu,
       ;;;linux-arch@vger.kernel.org;, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
Illegal-Object: Syntax error in Cc: addresses found on vger.kernel.org:
	Cc:	;linux-arch@vger.kernel.org
			^-extraneous tokens in mailbox, missing end of mailbox
Illegal-Object: Syntax error in Cc: addresses found on vger.kernel.org:
	Cc:	;linux-arch@vger.kernel.org
			^-extraneous tokens in mailbox, missing end of mailbox
Subject: Re: [PATCH 01/27] asm-generic: rename atomic.h to atomic-long.h
Message-ID: <20090430160654.GB5913@elte.hu>
References: <cover.1241105648.git.arnd@arndb.de> <33862b856508b9a61f6644355d2c9a4b6a4109a6.1241105648.git.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33862b856508b9a61f6644355d2c9a4b6a4109a6.1241105648.git.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnd Bergmann <arnd@arndb.de> wrote:

> The existing asm-generic/atomic.h only defines the
> atomic_long type. This renames it to atomic-long.h
> so we have a place to add a truly generic atomic.h
> that can be used on all non-SMP systems.
> 
> Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/alpha/include/asm/atomic.h                 |    2 +-
>  arch/arm/include/asm/atomic.h                   |    2 +-
>  arch/avr32/include/asm/atomic.h                 |    2 +-
>  arch/blackfin/include/asm/atomic.h              |    2 +-
>  arch/cris/include/asm/atomic.h                  |    2 +-
>  arch/frv/include/asm/atomic.h                   |    2 +-
>  arch/h8300/include/asm/atomic.h                 |    2 +-
>  arch/ia64/include/asm/atomic.h                  |    2 +-
>  arch/m32r/include/asm/atomic.h                  |    2 +-
>  arch/m68k/include/asm/atomic_mm.h               |    2 +-
>  arch/m68k/include/asm/atomic_no.h               |    2 +-
>  arch/microblaze/include/asm/atomic.h            |    2 +-
>  arch/mips/include/asm/atomic.h                  |    2 +-
>  arch/mn10300/include/asm/atomic.h               |    2 +-
>  arch/parisc/include/asm/atomic.h                |    2 +-
>  arch/powerpc/include/asm/atomic.h               |    2 +-
>  arch/s390/include/asm/atomic.h                  |    2 +-
>  arch/sh/include/asm/atomic.h                    |    2 +-
>  arch/sparc/include/asm/atomic_32.h              |    2 +-
>  arch/sparc/include/asm/atomic_64.h              |    2 +-
>  arch/x86/include/asm/atomic_32.h                |    2 +-
>  arch/x86/include/asm/atomic_64.h                |    2 +-

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
