Return-Path: <linux-kernel-owner+w=401wt.eu-S937350AbXGMXM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937350AbXGMXM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 19:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760419AbXGMXMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 19:12:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:50730 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758647AbXGMXMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 19:12:47 -0400
Subject: Re: [patch 5/6] ps3: BD/DVD/CD-ROM Storage Driver
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@ozlabs.org, James Bottomley <James.Bottomley@steeleye.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alessandro Rubini <rubini@vision.unipv.it>,
       Paul Mackerras <paulus@samba.org>, Jens Axboe <jens.axboe@oracle.com>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
In-Reply-To: <200707131619.54898.arnd@arndb.de>
References: <20070704132212.726923000@pademelon.sonytel.be>
	 <Pine.LNX.4.62.0707131541150.18802@pademelon.sonytel.be>
	 <1184335333.3402.20.camel@localhost.localdomain>
	 <200707131619.54898.arnd@arndb.de>
Content-Type: text/plain
Date: Sat, 14 Jul 2007 09:12:08 +1000
Message-Id: <1184368328.6059.271.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-13 at 16:19 +0200, Arnd Bergmann wrote:
> I'm pretty sure that no ppc64 machine needs alias resolution in the kernel,
> although some are VIPT. Last time we discussed this, Segher explained it
> to me, but I don't remember which way Cell does it. IIRC, it automatically
> flushes cache lines that are accessed through aliases. 

Ah yes, I remember reading about this automatic flushing thing. I don't
know how the caches actually work on most of our PPC's, but the fact is,
we don't have aliasing issues, so I can safely ignore it for a bit
longer :-)

There are some aliasing issues with the instruction cache specifically
on some 4xx models but that's irrelevant to this discussion (and I think
we handle them elsewhere anyway).

Ben.


