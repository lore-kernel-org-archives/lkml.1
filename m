Return-Path: <linux-kernel-owner+w=401wt.eu-S1752517AbZFDRuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbZFDRuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 13:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbZFDRuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 13:50:07 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:58670 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbZFDRuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 13:50:06 -0400
Date: Thu, 4 Jun 2009 19:40:59 +0200
From: Harald Welte <HaraldWelte@viatech.com>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Message-ID: <20090604174059.GB9823@prithivi.gnumonks.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <e9e943910906040900j6f334f29l42a9f5a57e9a1c8f@mail.gmail.com> <alpine.LFD.2.01.0906040910280.4880@localhost.localdomain> <200906041121.30845.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906041121.30845.lkml@morethan.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 11:21:28AM -0500, Michael S. Zick wrote:

> That is one of my pending questions - -
> (It is included as a comment at the appropriate point in my patchset.)
> 
> The VIA processors have MCR's not MTRR's - -

AFAIK, that was true for processors like the Winhcip / C6, i.e. earlier than
the C3.  The C3, C7 and later support 8 intel-style MTRR's.

> The C7-M processor uses "in-order retirement" not "out-of-order" - -
> I think the MCR's **should not** be set for "weak ordered writes" -

why would it matter on UP? as indicated, I'm not the expert here, but I thought
memory ordering issues only arise in SMP systems [or possibly with regard to
DMA, but as we already explored much earlier in this thread, drivers that access
DMA buffers whil the hardware owns them are buggy and need to be fixed]

Regards,
-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Free and Open Source Software Liaison
