Return-Path: <linux-kernel-owner+w=401wt.eu-S1752961AbZDSE5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbZDSE5y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 00:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbZDSE5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 00:57:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751015AbZDSE5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 00:57:39 -0400
Date: Sat, 18 Apr 2009 21:50:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v4
In-Reply-To: <alpine.LFD.2.00.0904181602030.2199@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0904182149240.2199@localhost.localdomain>
References: <49E00E9F.8030605@kernel.org> <49E4F6D6.6030709@kernel.org> <49E4F71F.10107@kernel.org> <alpine.LFD.2.00.0904141359020.18124@localhost.localdomain> <49E52A7A.4070607@kernel.org> <49E52D3F.1090206@kernel.org> <20090416093152.6605612d@hobbes>
 <alpine.LFD.2.00.0904160938090.4042@localhost.localdomain> <20090416165640.GA13927@elte.hu> <49E76864.9060309@kernel.org> <20090416172803.GB16618@elte.hu> <49E7916C.7050701@kernel.org> <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain>
 <49E99054.6050208@kernel.org> <alpine.LFD.2.00.0904181142530.4042@localhost.localdomain> <49EA57C4.1000603@kernel.org> <alpine.LFD.2.00.0904181602030.2199@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 18 Apr 2009, Linus Torvalds wrote:
> 
> And that _is_ a really odd hole. I wonder what it is all about. But the 
> approach does seem to have done the right thing.

I'll commit the reserve_region_with_split() change. There are no actual 
users of it now, so committing that change doesn't really do anything, but 
I like removing code, and with the only current potential user actively 
wanting just the simpler behavior, why keep the code around?

		Linus
