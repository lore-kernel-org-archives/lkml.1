Return-Path: <linux-kernel-owner+w=401wt.eu-S1759563AbYBMWgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563AbYBMWgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbYBMWgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:36:38 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:50582 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbYBMWgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:36:38 -0500
Date: Thu, 14 Feb 2008 00:36:21 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] x86: make dump_pagetable() static
Message-ID: <20080213223621.GC12383@cs181133002.pp.htv.fi>
References: <20080213213131.GA3383@cs181133002.pp.htv.fi> <1202941667.18204.14.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1202941667.18204.14.camel@brick>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 02:27:47PM -0800, Harvey Harrison wrote:
> On Wed, 2008-02-13 at 23:31 +0200, Adrian Bunk wrote:
> > dump_pagetable() can now become static.
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > 
> 
> I believe Andi Kleen wanted this kept global to make it easy to use when
> adding debugging code elsewhere.

That's not a reason as long as his code isn't in the tree (and he anyway 
has to patch the kernel for using it).

> Cheers,
> 
> Harvey

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

