Return-Path: <linux-kernel-owner+w=401wt.eu-S1755033AbZG2NL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbZG2NL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754844AbZG2NL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:11:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37232 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754841AbZG2NLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:11:55 -0400
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>	 <4A6F033B.7030302@mnementh.co.uk>	 <aec7e5c30907281948s2a0dcd0csd3e580251d6c4f5a@mail.gmail.com>	 <20090729115817.GA12223@rakim.wolfsonmicro.main>	 <aec7e5c30907290527w39a89895n285e932459e6c953@mail.gmail.com>	 <20090729124233.GA12802@rakim.wolfsonmicro.main> <aec7e5c30907290551y77edc6d7qb7b3d787215c2b4@mail.gmail.com> <4A704777.70001@mnementh.co.uk> (sfid-20090729_135848_331445_664D487E)
Message-Id: <9C1AC001-2FA6-4C19-B9D3-23FB63BAF20B@opensource.wolfsonmicro.com>
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ian Molton <ian@mnementh.co.uk>
In-Reply-To: <4A704777.70001@mnementh.co.uk> (sfid-20090729_135848_331445_664D487E)
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7A341)
Mime-Version: 1.0 (iPhone Mail 7A341)
Subject: Re: MMC: Make the configuration memory resource optional
Date: Wed, 29 Jul 2009 14:11:52 +0100
Cc: Magnus Damm <magnus.damm@gmail.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Pierre Ossman <drzeus@drzeus.cx>, Magnus Damm <damm@opensource.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 Jul 2009, at 13:58, Ian Molton <ian@mnementh.co.uk> wrote:

> Magnus Damm wrote:
>
>>> Indeed.  It's actually much worse than you say, each individual ARM
>>> architecture has its own clock API implementation of varying  
>>> quality and
>>> of course there are architectures that don't do the clock API at  
>>> all.
>> Yeah. This is exactly why I don't want to block on the clocklib  
>> implementation.
>
> Yeah, good idea... lets ignore the problem until its so big we cant  
> fix it at all...

The problem here is sufficiently substantial that I'd be impressed if  
we managed to get a good solution in within a single kernel release.  
This does help encourage people to keep local hacks but those are much  
more realistic.
