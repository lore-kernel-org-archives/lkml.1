Return-Path: <linux-kernel-owner+w=401wt.eu-S932253AbYETOKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253AbYETOKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 10:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbYETOKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 10:10:04 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:37371 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561AbYETOKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 10:10:03 -0400
Date: Tue, 20 May 2008 17:07:52 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Marc St-Jean <Marc_St-Jean@pmc-sierra.com>,
       Ralf Baechle <ralf@linux-mips.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mips@linux-mips.org
Subject: Re: references from Makefiles to non-existent CONFIG variables
Message-ID: <20080520140752.GA31216@cs181133002.pp.htv.fi>
References: <alpine.LFD.1.10.0805171641190.14930@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805171641190.14930@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2008 at 04:45:58PM -0400, Robert P. J. Day wrote:
> 
>   here's the current, unadulterated list of references from Makefiles
> to CONFIG variables that are not defined in any Kconfig file.  once
> again, enjoy.
>...
> ===== MSPETH =====
> ./arch/mips/pmc-sierra/msp71xx/Makefile:obj-$(CONFIG_MSPETH) += msp_eth.o
>...

This PMC MSP71xx platform in the kernel was AFAIR never in a usable 
state (read: even compilation fails).

Marc, will you (or anyone else) bring it into shape or should I send a 
patch removing it?

> rday

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

