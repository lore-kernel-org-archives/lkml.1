Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbYDTIvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbYDTIvi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 04:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbYDTIv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 04:51:28 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:51212 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbYDTIv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 04:51:27 -0400
Date: Sun, 20 Apr 2008 11:51:04 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080420085104.GG1595@cs181133002.pp.htv.fi>
References: <200804181737.m3IHbabI010051@hera.kernel.org> <20080418142934.38ce6bf4.akpm@linux-foundation.org> <20080419142329.GA5339@elte.hu> <20080419145948.GA4528@lintop> <20080420080901.GF1595@cs181133002.pp.htv.fi> <20080420090623.7b173ef1@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080420090623.7b173ef1@the-village.bc.nu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 09:06:23AM +0100, Alan Cox wrote:
> > The stack problems in the kernel tend to not be in arch code, and if 
> > we don't get i386 to always run with 4k stacks there's no chance that 
> > it will ever work reliably on other architectures.
> 
> Not really the case - embedded tends not to use deep stacks of drivers.

Something like nfsd-over-xfs-over-raid is (or was) the most common 
problem - and this or similar stackings might be used in NAS devices.

> Alan

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

