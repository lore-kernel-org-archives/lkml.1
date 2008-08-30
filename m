Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbYH3Spx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbYH3Spx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 14:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbYH3Spp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 14:45:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34969 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752769AbYH3Spo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 14:45:44 -0400
Date: Sat, 30 Aug 2008 11:43:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, David Witbrodt <dawitbro@sbcglobal.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit
 a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
In-Reply-To: <86802c440808301107n4561e815ldf53183c92a7bc93@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0808301141590.3290@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>  <200808292157.24179.rjw@sisk.pl>  <alpine.LFD.1.10.0808291434110.3300@nehalem.linux-foundation.org>  <200808300030.32905.rjw@sisk.pl>  <alpine.LFD.1.10.0808301012060.3290@nehalem.linux-foundation.org>
 <86802c440808301107n4561e815ldf53183c92a7bc93@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 30 Aug 2008, Yinghai Lu wrote:
>
> again, should use MCFG end as the res _end

No. Again - we shouldn't DO that insane crap.

We simply shouldn't try to compare the BAR start with randomly chosen 
things.

So the crap got reverted, and it's not going to get done again. Get over 
it.


			Linus
