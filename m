Return-Path: <linux-kernel-owner+w=401wt.eu-S932145AbZCRV7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145AbZCRV7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758983AbZCRV6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:58:31 -0400
Received: from www.tglx.de ([62.245.132.106]:45887 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761038AbZCRV6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:58:30 -0400
Date: Wed, 18 Mar 2009 22:57:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [git-pull -tip] x86: mpparse cleanup
In-Reply-To: <1237403503.22438.21.camel@ht.satnam>
Message-ID: <alpine.LFD.2.00.0903182254060.29264@localhost.localdomain>
References: <1237314836.3212.10.camel@localhost.localdomain>  <1237380351.3042.0.camel@ht.satnam> <20090318141115.GA23034@elte.hu>  <1237392355.12866.2.camel@ht.satnam> <20090318161829.GC21331@elte.hu>  <20090318163933.GA29854@elte.hu> <1237396487.22438.2.camel@ht.satnam>
  <20090318190257.GB16286@elte.hu> <1237403503.22438.21.camel@ht.satnam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Mar 2009, Jaswinder Singh Rajput wrote:
> > > 
> > > As I told you earlier, I cannot check this on my side. Only 
> > > suspect will be check_irq_src() please test this patch if this 
> > > does not work I will revert check_irq_src():
> > 
> > no need to test on your side. If a patch is broken the first step is 
> > to take a look at the patch and think about it. For example this 
> > block:
> > 
> 
> Subject: [PATCH] x86: mpparse introduced few helper functions
> 
> Introduced helper functions:
> skip_entry, smp_reserve_bootmem, check_irq_src and check_slot

And to make review and testing simpler can we please have separate
patches for those helper functions as far as it is possible.

Thanks,

	tglx


