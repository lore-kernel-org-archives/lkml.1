Return-Path: <linux-kernel-owner+w=401wt.eu-S1757152AbZFOIOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbZFOIOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbZFOIOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:14:05 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:61068 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbZFOIOD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:14:03 -0400
X-SpamScore: -32
X-BigFish: VPS-32(zz1432R98dR1447R1805Mzz1202hzzz32i6bh17ch43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KL9TJ9-04-Q1U-01
Date: Mon, 15 Jun 2009 10:13:55 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org
Subject: Re: dma-debug: check_for_stack background?
Message-ID: <20090615081355.GA5139@amd.com>
References: <4A3547DD.2010809@s5r6.in-berlin.de> <20090614212018.GD20442@fluff.org.uk> <4A356F0E.9020809@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4A356F0E.9020809@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 15 Jun 2009 08:13:55.0381 (UTC) FILETIME=[39E04650:01C9ED91]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 11:43:42PM +0200, Stefan Richter wrote:
> Ben Dooks wrote:
>> On Sun, Jun 14, 2009 at 08:56:29PM +0200, Stefan Richter wrote:
>>> the DMA debug facility warns  about mappings of on-stack memory.  
>>> What's the problem with that?
> ...
>> I'm not sure if it is possible on all architectures, however the
>> DMA mapping documentation prohibts the use of stack memory.
>
> Ah, it has all been documented in plain sight for ages.  Thanks for the  
> pointer.

Problem is that the stack might go away or could be otherwise reused
while the DMA is in-flight. This could cause really hard to debug
problems.

	Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

