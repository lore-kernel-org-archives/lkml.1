Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbYCZWte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbYCZWte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 18:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbYCZWtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 18:49:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753575AbYCZWtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 18:49:24 -0400
Date: Wed, 26 Mar 2008 15:47:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Ingo Molnar <mingo@elte.hu>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Gary Hade <garyhade@us.ibm.com>, Thomas Meyer <thomas@m3y3r.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, pm@debian.org
Subject: Re: [patch] pci: revert "PCI: remove transparent bridge sizing"
In-Reply-To: <1206570546.6926.30.camel@pasglop>
Message-ID: <alpine.LFD.1.00.0803261544210.2775@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0803251445500.2775@woody.linux-foundation.org>  <20080326101450.GA9060@jurassic.park.msu.ru>  <20080326135458.GA27621@elte.hu> <20080326180701.GA6249@us.ibm.com>  <alpine.LFD.1.00.0803261132310.2775@woody.linux-foundation.org> 
 <20080326203012.GB6249@us.ibm.com>  <alpine.LFD.1.00.0803261344430.2775@woody.linux-foundation.org>  <20080326205828.GA15225@jurassic.park.msu.ru>  <alpine.LFD.1.00.0803261416390.2775@woody.linux-foundation.org>  <1206568675.6926.7.camel@pasglop> 
 <20080326221027.GA7959@elte.hu> <1206570546.6926.30.camel@pasglop>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 27 Mar 2008, Benjamin Herrenschmidt wrote:
> 
> I was talking about IO not memory mostly here.

Yeah, low IO is also reserved on PC's (the low 256 IO ports are 
motherboard resources and contain stuff like legacy DMA channel setup 
etc).

You could imagine having it behind a PCI bridge, but in practice it's 
always on the NB/SB (and if you want to support some of the odder things 
like the NMI reason and the i387 error ports, they pretty much have to 
be - it would be insane to make a special PCI chips on a separate bus 
that does things like that).

			Linus
