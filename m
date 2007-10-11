Return-Path: <linux-kernel-owner+w=401wt.eu-S1758649AbXJKPVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbXJKPVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 11:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755585AbXJKPVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 11:21:05 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47202 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755581AbXJKPVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 11:21:02 -0400
Date: Thu, 11 Oct 2007 17:21:30 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Joerg Roedel <joerg.roedel@amd.com>,
       "LKML (Cc removed)" <linux-kernel@vger.kernel.org>
Subject: Re: coding for optimizations (Re: [PATCH 1/2] i386: mce cleanup
	part1: functional change)
Message-ID: <20071011152129.GY16424@stusta.de>
References: <11919341961890-git-send-email-joerg.roedel@amd.com> <11919341961530-git-send-email-joerg.roedel@amd.com> <E1IfHZg-0003dp-FA@flower> <20071009160605.GC13205@amd.com> <20071009173317.GD22435@flower.upol.cz> <20071009183011.GE13205@amd.com> <20071010231428.GU16424@stusta.de> <20071011152609.GF22435@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071011152609.GF22435@flower.upol.cz>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 05:26:09PM +0200, Oleg Verych wrote:
> On Thu, Oct 11, 2007 at 01:14:29AM +0200, Adrian Bunk wrote:
> [] 
> > It's also a quite ill idea to think about whether gcc might produce a 
> > few bytes more or less code at the if when there's such a long printk() 
> > in the middle...
> 
> printk() problem was discussed with proper banana userspace replacement
> proposition by me, so i don't care much.
> 
> Though, why MCE can't be enabled/disabled by config option? Native
> engineers from proper company should know what processors have this
> feature... If kconfig isn't flexible for this, i'm glad to hear
> opinions. If it's needed anyway, then sorry.

You should better say sorry for not having checked that it can already 
be disabled with a kconfig option...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

