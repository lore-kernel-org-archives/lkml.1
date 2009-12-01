Return-Path: <linux-kernel-owner+w=401wt.eu-S1752658AbZLASHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbZLASHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 13:07:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbZLASHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 13:07:03 -0500
Received: from [83.170.124.135] ([83.170.124.135]:43710 "EHLO
	pluto.daelnet.net" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbZLASHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 13:07:01 -0500
Message-ID: <4B155B4A.9050405@cybus.co.uk>
Date: Tue, 01 Dec 2009 18:07:06 +0000
From: Jonathan Miles <jon@cybus.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: OOM kernel behaviour
References: <4B1402FC.80307@cybus.co.uk> <alpine.DEB.2.00.0911301253410.18682@router.home> <4B14E8A2.4020500@cybus.co.uk> <alpine.DEB.2.00.0912010949400.8841@router.home>
In-Reply-To: <alpine.DEB.2.00.0912010949400.8841@router.home>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/09 16:08 Christoph Lameter said the following:

> Anonymous page use may fluctuate unpredictably based on the processes
> being started. A spike may take out your system.

I agree that swap should be there for these times. Once I'm happy that
the system behaves properly without it, I'll re-enable swap and set a
low swappiness value.

> The kernel will prefer to reclaim from clean page cache over
> swapping in general. The aggressiveness of swap can be controlled via
> /proc/sys/vm/swappiness.
> 
> The OOM killer output shows that the DMA is zone is marked as
> unreclaimable but the allocation causing it is not using DMA. Other zones
> all seem to have enough memory. Is this straight 2.6.31? No use of
> containers, memory policies etc right?

Okay, so my kernel shouldn't be behaving like this?

It's Ubuntu's (Karmic) 2.6.31 .deb and I don't know exactly what they've
done to it, but AFAIK, no containers or policies. I'll compile 2.6.31.6
and test with that. Won't be able to do this until Friday, so will check
back in then.

Thanks,

J
