Return-Path: <linux-kernel-owner+w=401wt.eu-S1753075AbZFPIPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbZFPIPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbZFPIOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:14:46 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:32025 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbZFPIOo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:14:44 -0400
X-SpamScore: -31
X-BigFish: VPS-31(zz1432R98dR1447R1805M873fizz1202hzzz32i6bh17ch43j)
X-WSS-ID: 0KLBO85-01-0VJ-01
Date: Tue, 16 Jun 2009 10:14:28 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: stefanr@s5r6.in-berlin.de, ben-linux@fluff.org,
       linux-kernel@vger.kernel.org
Subject: Re: dma-debug: check_for_stack background?
Message-ID: <20090616081428.GH5139@amd.com>
References: <20090614212018.GD20442@fluff.org.uk> <4A356F0E.9020809@s5r6.in-berlin.de> <20090615081355.GA5139@amd.com> <20090616151628V.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090616151628V.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 16 Jun 2009 08:14:29.0243 (UTC) FILETIME=[7878F4B0:01C9EE5A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 03:16:37PM +0900, FUJITA Tomonori wrote:
> On Mon, 15 Jun 2009 10:13:55 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > On Sun, Jun 14, 2009 at 11:43:42PM +0200, Stefan Richter wrote:
> > > Ben Dooks wrote:
> > >> On Sun, Jun 14, 2009 at 08:56:29PM +0200, Stefan Richter wrote:
> > >>> the DMA debug facility warns  about mappings of on-stack memory.  
> > >>> What's the problem with that?
> > > ...
> > >> I'm not sure if it is possible on all architectures, however the
> > >> DMA mapping documentation prohibts the use of stack memory.
> > >
> > > Ah, it has all been documented in plain sight for ages.  Thanks for the  
> > > pointer.
> > 
> > Problem is that the stack might go away or could be otherwise reused
> > while the DMA is in-flight. This could cause really hard to debug
> > problems.
> 
> Not true. Even if you use the stack buffer for DMA synchronously, it
> doesn't work (we had the bad code like starting dma and waiting for
> the completion).

I've not written that this is the only problem. I know that there may be
others like the one you experienced. But what I wrote could also happen
and is a problem :)

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

