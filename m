Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600AbXLDN6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbXLDN6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 08:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716AbXLDNzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 08:55:20 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:48370 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753386AbXLDNzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 08:55:17 -0500
Date: Tue, 4 Dec 2007 14:55:10 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] x86: revert X86_HT semantics change
Message-ID: <20071204135510.GA15974@stusta.de>
References: <20071115161703.GR4250@stusta.de> <20071115180436.GA23517@uranus.ravnborg.org> <alpine.LFD.0.9999.0711151904300.3112@localhost.localdomain> <20071115181945.GS4250@stusta.de> <20071204132905.GJ31590@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071204132905.GJ31590@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 02:29:05PM +0100, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > The x86 unification resulted in CONFIG_X86_HT no longer being set if 
> > (X86_32 && MK8).
> > 
> > After grep'ing through the tree I think the problem is that different
> > places have different assumptions about the semantics of CONFIG_X86_HT,
> > either
> > - hyperthreading or
> > - multicore
> > 
> > This should be sorted out properly, but until then we should keep the
> > 2.6.23 status quo.
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> thanks, applied. This is for 2.6.24, right?

Yes.

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

