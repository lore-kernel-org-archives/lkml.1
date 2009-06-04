Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbZFDUQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbZFDUQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 16:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZFDUQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 16:16:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49487 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbZFDUQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 16:16:35 -0400
To: Harald Welte <HaraldWelte@viatech.com>
Cc: "Michael S. Zick" <lkml@morethan.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
From: Andi Kleen <andi@firstfloor.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain>
	<e9e943910906040900j6f334f29l42a9f5a57e9a1c8f@mail.gmail.com>
	<alpine.LFD.2.01.0906040910280.4880@localhost.localdomain>
	<200906041121.30845.lkml@morethan.org>
	<20090604174059.GB9823@prithivi.gnumonks.org>
Date: Thu, 04 Jun 2009 22:16:35 +0200
In-Reply-To: <20090604174059.GB9823@prithivi.gnumonks.org> (Harald Welte's message of "Thu, 4 Jun 2009 19:40:59 +0200")
Message-ID: <873aaf4uvw.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harald Welte <HaraldWelte@viatech.com> writes:
>
> why would it matter on UP? as indicated, I'm not the expert here, but I thought
> memory ordering issues only arise in SMP systems [or possibly with regard to
> DMA, but as we already explored much earlier in this thread, drivers that access
> DMA buffers whil the hardware owns them are buggy and need to be fixed]

Sorry we didn't establish that. Accessing data structures that are
also accessed by DMA hardware is pretty common in fact and memory
ordering issues also come up regularly (e.g. all the infamous PCI
posting bugs)

What we established is that the drivers don't use LOCK for it
(or at least we think that's very unlikely)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
