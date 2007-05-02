Return-Path: <linux-kernel-owner+w=401wt.eu-S2993313AbXEBPFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993313AbXEBPFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993314AbXEBPFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:05:48 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35730 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2993313AbXEBPFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:05:46 -0400
Date: Wed, 2 May 2007 17:05:46 +0200
From: Adrian Bunk <bunk@stusta.de>
To: David Rientjes <rientjes@google.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] compiler: define __attribute_unused__
Message-ID: <20070502150546.GF3531@stusta.de>
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com> <1178084403.28659.222.camel@localhost.localdomain> <Pine.LNX.4.64.0705012254160.21685@chino.kir.corp.google.com> <1178087393.28659.238.camel@localhost.localdomain> <Pine.LNX.4.64.0705012336430.22339@chino.kir.corp.google.com> <1178089444.28659.246.camel@localhost.localdomain> <Pine.LNX.4.64.0705020020420.22717@chino.kir.corp.google.com> <20070502145550.GE3531@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070502145550.GE3531@stusta.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 04:55:50PM +0200, Adrian Bunk wrote:
> 
> "many ... are marked __attribute__ ((unused))" is not true:
> $ grep -r __attribute_used__ * | wc -l
> 60
> $ 

Sorry, my fault - I confused used and unused.

>...
> Unused static non-inline functions are the only functions resulting in 
> warnings when being unused.
> If we don't want gcc to emit warnings for such, we could disable them 
> globally.

But this point still stands:

If we don't want any warnings with CONFIG_PCI=n, CONFIG_SYSFS=n or
CONFIG_PROC_FS=n, we'd have to annotate _many_ functions.

If the lonterm goal is to compile the kernel with -Werror then we need 
-Wno-unused-function, not annotating individual functions.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

