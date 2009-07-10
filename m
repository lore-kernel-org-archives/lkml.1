Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbZGJUEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbZGJUEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 16:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbZGJUEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 16:04:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:1238 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302AbZGJUEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 16:04:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,379,1243839600"; 
   d="scan'208";a="429219472"
Date: Fri, 10 Jul 2009 13:03:44 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, dann frazier <dannf@hp.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Stephen Frost <sfrost@snowman.net>
Subject: Re: [PATCH] x86/pci: insert ioapic resource before assign
 unassigned resource for pci -v2
Message-ID: <20090710130344.75f4d243@jbarnes-g45>
In-Reply-To: <4A576E04.9070004@kernel.org>
References: <20090630180300.GA9971@ldl.fc.hp.com>
	<4A4A5B01.9040200@kernel.org>
	<20090703225708.GA30664@ldl.fc.hp.com>
	<4A4FADDC.30606@kernel.org>
	<20090709185945.GG2613@ldl.fc.hp.com>
	<4A564263.5010305@kernel.org>
	<4A564634.1020708@kernel.org>
	<4A564990.3060202@kernel.org>
	<1247172044.3898.147.camel@mulgrave.site>
	<4A56641B.9050204@kernel.org>
	<4A576E04.9070004@kernel.org>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jul 2009 09:36:20 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> Stephen reported that his DL585 G2 need noapic after 2.6.22 (?)
> 
> Dann bisected
>   --------------------------------------------------------------------
>   commit 30a18d6c3f1e774de656ebd8ff219d53e2ba4029
>   Date:   Tue Feb 19 03:21:20 2008 -0800
> 
>       x86: multi pci root bus with different io resource range, on
>       64-bit
>   --------------------------------------------------------------------
> caused the problem.
> 

Applied to my for-linus tree, thanks Yinghai.

-- 
Jesse Barnes, Intel Open Source Technology Center
