Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbYIDQWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbYIDQWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 12:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbYIDQWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 12:22:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751404AbYIDQWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 12:22:44 -0400
Date: Thu, 4 Sep 2008 09:21:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Alok Kataria <akataria@vmware.com>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
In-Reply-To: <20080904160036.GA18382@elte.hu>
Message-ID: <alpine.LFD.1.10.0809040920000.3381@nehalem.linux-foundation.org>
References: <20080904150339.896115280@linutronix.de> <20080904153620.GC7120@elte.hu> <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org> <20080904160036.GA18382@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Sep 2008, Ingo Molnar wrote:
> 
> ah - perhaps a dynamic statistical approach with an estimation of 
> worst-case calibration error (~= standard deviation) and a quality 
> threshold to reach? That could dramatically increase the number of 
> samples while also making it much faster in practice. Nifty!

Oh, no, I'm _much_ more nifty than that!

Instead of being very clever, I have a very _stupid_ algorithm, one that 
has very hardcoded expectations of exactly what it will see. And if it 
doesn't see exactly that, it just fails early. 

I'd post the patch, but I really need to actually _test_ it first, and I 
haven't rebooted yet.

		Linus
