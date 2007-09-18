Return-Path: <linux-kernel-owner+w=401wt.eu-S1758920AbXIRVnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920AbXIRVnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 17:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbXIRVnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 17:43:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44385 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751948AbXIRVnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 17:43:08 -0400
Date: Tue, 18 Sep 2007 14:42:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] Clarify pci_iomap() usage for MMIO-only devices
In-Reply-To: <46F04386.8010209@garzik.org>
Message-ID: <alpine.LFD.0.999.0709181439190.16478@woody.linux-foundation.org>
References: <43e72e890709171322x76ab6b70xd29bf97e3643c553@mail.gmail.com> 
 <20070918113401.6a8a737f@the-village.bc.nu> 
 <43e72e890709181146s604e0f9fl8b0c16627469c77f@mail.gmail.com> 
 <alpine.LFD.0.999.0709181159440.16478@woody.linux-foundation.org> 
 <43e72e890709181207j7c85dc29sb355a9f5a4207411@mail.gmail.com> 
 <alpine.LFD.0.999.0709181219020.16478@woody.linux-foundation.org> 
 <43e72e890709181312sf2b421cn49be3389b3786a2a@mail.gmail.com> 
 <alpine.LFD.0.999.0709181323260.16478@woody.linux-foundation.org>
 <43e72e890709181402x7335d0acp306cf576fac6c070@mail.gmail.com>
 <alpine.LFD.0.999.0709181408390.16478@woody.linux-foundation.org>
 <46F04386.8010209@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Sep 2007, Jeff Garzik wrote:
> 
> Most new hardware is MMIO-only, making ioread32() only for drivers that care
> about legacy IO support, something that is being slowly phased out.  e.g.
> legacy IDE, legacy 10/100 mbps ethernet NICs with the dual MMIO/PIO register
> spaces.

Hey, I think your patch was better than the one that just assumed that you 
can do "read*/write*()" on an iomap(). If people really want it, I don't 
care *that* much.

I just think that the arguments that have been raised so far have really 
been very weak. There really is no "performance" argument without some 
kinds of numbers.

I just think that proliferation of IO interfaces is a bad idea. 

			Linus
