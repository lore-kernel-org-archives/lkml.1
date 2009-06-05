Return-Path: <linux-kernel-owner+w=401wt.eu-S1755075AbZFEHjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbZFEHjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 03:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbZFEHj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 03:39:26 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:53870 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbZFEHj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 03:39:26 -0400
Date: Fri, 5 Jun 2009 09:30:18 +0200
From: Harald Welte <HaraldWelte@viatech.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Michael S. Zick" <lkml@morethan.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Message-ID: <20090605073018.GH6411@prithivi.gnumonks.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <e9e943910906040900j6f334f29l42a9f5a57e9a1c8f@mail.gmail.com> <alpine.LFD.2.01.0906040910280.4880@localhost.localdomain> <200906041121.30845.lkml@morethan.org> <20090604174059.GB9823@prithivi.gnumonks.org> <873aaf4uvw.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <873aaf4uvw.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 10:16:35PM +0200, Andi Kleen wrote:
> Harald Welte <HaraldWelte@viatech.com> writes:
> >
> > why would it matter on UP? as indicated, I'm not the expert here, but I thought
> > memory ordering issues only arise in SMP systems [or possibly with regard to
> > DMA, but as we already explored much earlier in this thread, drivers that access
> > DMA buffers whil the hardware owns them are buggy and need to be fixed]
> 
> Sorry we didn't establish that. Accessing data structures that are
> also accessed by DMA hardware is pretty common in fact and memory
> ordering issues also come up regularly (e.g. all the infamous PCI
> posting bugs)
> 
> What we established is that the drivers don't use LOCK for it
> (or at least we think that's very unlikely)

Yes, sorry for not mentioning that.  I was implicitly thinking of "not using an
appropriate locking method"

-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Free and Open Source Software Liaison
