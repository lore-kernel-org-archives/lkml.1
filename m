Return-Path: <linux-kernel-owner+w=401wt.eu-S1759442AbYDKHze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442AbYDKHze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 03:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbYDKHzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 03:55:12 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:27139 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759343AbYDKHzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 03:55:10 -0400
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>,
       e1000-list <e1000-devel@lists.sourceforge.net>,
       linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>, Greg KH <greg@kroah.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch] e1000=y && e1000e=m regression fix
From: Andi Kleen <andi@firstfloor.org>
References: <20080408193245.GG11962@parisc-linux.org>
	<20080408195123.GA28148@elte.hu> <47FBCE00.2020309@garzik.org>
	<20080408200652.GC28148@elte.hu> <47FBD34A.6080508@garzik.org>
	<20080408203314.GA28952@elte.hu> <47FBDBE9.9040700@garzik.org>
	<20080409193850.GA11763@elte.hu> <47FD2325.2030705@intel.com>
	<47FE5C89.5060209@intel.com> <20080410192714.GA14055@elte.hu>
	<47FE8566.5040809@intel.com>
	<20080410144409.6a1da266.rdunlap@xenotime.net>
Date: Fri, 11 Apr 2008 09:54:35 +0200
In-Reply-To: <20080410144409.6a1da266.rdunlap@xenotime.net> (Randy Dunlap's message of "Thu, 10 Apr 2008 14:44:09 -0700")
Message-ID: <87y77kltc4.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Apr 2008 07:47:51.0548 (UTC) FILETIME=[5821CBC0:01C89BA8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <rdunlap@xenotime.net> writes:
>
> to defconfig ... and also to change
> CONFIG_FUSION=y
> to
> CONFIG_FUSION=n
> while there  :)

In my experience with FUSION=y and AIC78xx=y most of the relatively
modern (2000+) pre SAS SCSI systems are covered, at least near all
those without special RAID controllers. That is why I kept both of
those enabled in the defconfigs originally.

Might actually make sense to update this for SAS, but I don't have
a good feeling what chipsets are really popular here.

-Andi
