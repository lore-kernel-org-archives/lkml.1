Return-Path: <linux-kernel-owner+w=401wt.eu-S1758751AbXJKP7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751AbXJKP7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 11:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbXJKP7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 11:59:35 -0400
Received: from barikada.upol.cz ([158.194.242.200]:34811 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbXJKP7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 11:59:34 -0400
Date: Thu, 11 Oct 2007 18:13:50 +0200
To: Adrian Bunk <bunk@kernel.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>,
       "LKML (Cc removed)" <linux-kernel@vger.kernel.org>
Subject: Re: coding for optimizations (Re: [PATCH 1/2] i386: mce cleanup part1: functional change)
Message-ID: <20071011161350.GG22435@flower.upol.cz>
References: <11919341961890-git-send-email-joerg.roedel@amd.com> <11919341961530-git-send-email-joerg.roedel@amd.com> <E1IfHZg-0003dp-FA@flower> <20071009160605.GC13205@amd.com> <20071009173317.GD22435@flower.upol.cz> <20071009183011.GE13205@amd.com> <20071010231428.GU16424@stusta.de> <20071011152609.GF22435@flower.upol.cz> <20071011152129.GY16424@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071011152129.GY16424@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 05:21:30PM +0200, Adrian Bunk wrote:
> On Thu, Oct 11, 2007 at 05:26:09PM +0200, Oleg Verych wrote:
> > On Thu, Oct 11, 2007 at 01:14:29AM +0200, Adrian Bunk wrote:
> > [] 
> > > It's also a quite ill idea to think about whether gcc might produce a 
> > > few bytes more or less code at the if when there's such a long printk() 
> > > in the middle...
> > 
> > printk() problem was discussed with proper banana userspace replacement
> > proposition by me, so i don't care much.
> > 
> > Though, why MCE can't be enabled/disabled by config option? Native
> > engineers from proper company should know what processors have this
> > feature... If kconfig isn't flexible for this, i'm glad to hear
> > opinions. If it's needed anyway, then sorry.
> 
> You should better say sorry for not having checked that it can already 
> be disabled with a kconfig option...

Talk is not about wana-build-MCE-in, given to the user's sake. But about
flexible selection of this code, if it is really supported by CPU, when
user have it enabled (see winchip/preventium sub-thread). More work, it
is not such quick patch, certainly, but this is needed for famous i386.

I wonder, why such patch wasn't introduced long time ago. Modern
(cheap) chips have no MCE?
____
