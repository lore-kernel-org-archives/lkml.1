Return-Path: <linux-kernel-owner+w=401wt.eu-S1756599AbYIDSfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbYIDSfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756263AbYIDSfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:35:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41786 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224AbYIDSfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:35:16 -0400
Message-ID: <48C02957.40708@zytor.com>
Date: Thu, 04 Sep 2008 11:30:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Alok Kataria <akataria@vmware.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
References: <20080904150339.896115280@linutronix.de> <20080904153620.GC7120@elte.hu> <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org> <20080904160036.GA18382@elte.hu> <alpine.LFD.1.10.0809040920000.3381@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809041021110.3400@nehalem.linux-foundation.org> <20080904190728.59634020@lxorguk.ukuu.org.uk> <alpine.LFD.1.10.0809041114030.3400@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0809041114030.3400@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> Of course, the 2048 PIT ticks is just a random choice. It could be any 
> multiple of 256 ticks, so that error can be made smaller. Maybe it's worth 
> spending 10ms on this, and get it down by a factor of five (at which point 
> the error on the PIT frequency is probably in the same order of 
> magnitude).
> 

FWIW, typical error on the 14.31818 MHz clock (used as the PIT, PMTMR 
and HPET timebase in most systems) is usually ±50 ppm.  High-quality 
motherboards which use a TCXO for the 14.31818 MHz clock would have
around ±1 ppm.

	-hpa
