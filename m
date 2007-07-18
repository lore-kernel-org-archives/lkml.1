Return-Path: <linux-kernel-owner+w=401wt.eu-S1761963AbXGRUZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761963AbXGRUZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 16:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbXGRUZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 16:25:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52424 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbXGRUZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 16:25:04 -0400
Message-ID: <469E7709.9070801@zytor.com>
Date: Wed, 18 Jul 2007 13:24:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Matt Mackall <mpm@selenic.com>, Jonathan Campbell <jon@nerdgrounds.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Patches for REALLY TINY 386 kernels
References: <469A8AED.7070207@nerdgrounds.com> <p737ioyxwyq.fsf@bingen.suse.de> <469E3806.4030804@zytor.com> <20070718194137.GG11166@waste.org> <20070718201043.GF3898@one.firstfloor.org>
In-Reply-To: <20070718201043.GF3898@one.firstfloor.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> I was waiting for someone to make that "point" ...
> 
>> Every byte you can shave off the compressed kernel image is another
>> byte you can use for userspace on your FLASH.
> 
> Now let's see if that 1MB 386 contains any flash at all. Guesses?  
> 

CPUID is hardly something you want to give up for modern embedded stuff.
 I haven't seen any new embedded stuff using anything less than a 586,
and even those are disappearing quickly in favor of Geode and VIA.

However, compressed size reductions as an abstract thing is useful for
this market.  Just not these particular ones.  The first thing to get
there is probably an LZMA-based compressor instead of gzip.

	-hpa
