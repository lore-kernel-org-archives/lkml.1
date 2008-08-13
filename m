Return-Path: <linux-kernel-owner+w=401wt.eu-S1755779AbYHMI4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbYHMI4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbYHMI40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:56:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47081 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258AbYHMI4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:56:25 -0400
Date: Wed, 13 Aug 2008 10:55:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: Johannes Weiner <hannes@saeurebad.de>,
       Linus Torvalds <torvalds@linux-foundation.org>, dhowells@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Propagate new nonpanic bootmem macros to
	CONFIG_HAVE_ARCH_BOOTMEM_NODE
Message-ID: <20080813085509.GC23417@elte.hu>
References: <87skt99vmz.fsf@skyscraper.fehenstaub.lan> <48A2B7BA.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A2B7BA.76E4.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> Sorry for not noticing this:
> Acked-by: Jan Beulich <jbeulich@novell.com>
> 
> >>> Johannes Weiner <hannes@saeurebad.de> 13.08.08 10:17 >>>
> Commit 74768ed833344b "page allocator: use no-panic variant of
> alloc_bootmem() in alloc_large_system_hash()" introduced two new
> _nopanic macros which are undefined for CONFIG_HAVE_ARCH_BOOTMEM_NODE.
> 
> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>

btw., i dont think the fix is complete, a quick grep shows:

  arch/avr32/Kconfig:config HAVE_ARCH_BOOTMEM_NODE

	Ingo
