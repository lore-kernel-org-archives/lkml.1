Return-Path: <linux-kernel-owner+w=401wt.eu-S934632AbXGKXPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934632AbXGKXPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758355AbXGKXPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:15:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:60516 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755896AbXGKXPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:15:33 -0400
From: Andreas Schwab <schwab@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>,
       Jason Wessel <jason.wessel@windriver.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] Pass -g to assembler under CONFIG_DEBUG_INFO
References: <46955BB1.20200@windriver.com>
	<20070711224327.9B0ED4D0555@magilla.localdomain>
	<20070711160335.8705f742.akpm@linux-foundation.org>
X-Yow: A GRAM??  A BRAM...  A GROOM...  A BROOM...  Oh, Yeh!!  Wash the
 ROOM!!
Date: Thu, 12 Jul 2007 01:15:23 +0200
In-Reply-To: <20070711160335.8705f742.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed\, 11 Jul 2007 16\:03\:35 -0700")
Message-ID: <jeps2yjzw4.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> diff -puN Makefile~pass-g-to-assembler-under-config_debug_info Makefile
> --- a/Makefile~pass-g-to-assembler-under-config_debug_info
> +++ a/Makefile
> @@ -498,6 +498,7 @@ endif
>  
>  ifdef CONFIG_DEBUG_INFO
>  CFLAGS		+= -g
> +AFLAGS		+= $(call as-option, -gdwarf)

The option is officially called -gdwarf-2, and -gdwarf2 is an alias for
backward compatibility.  But -gdwarf is ambigous and will error out.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
