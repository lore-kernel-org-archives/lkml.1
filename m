Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbYFTTbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbYFTTbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 15:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750892AbYFTTbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 15:31:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750837AbYFTTbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 15:31:36 -0400
Date: Fri, 20 Jun 2008 12:30:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
cc: Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Mingarelli <Thomas.Mingarelli@hp.com>
Subject: Re: [WATCHDOG] v2.6.26 hpwdt.c fixes
In-Reply-To: <20080620190538.GA30161@redhat.com>
Message-ID: <alpine.LFD.1.10.0806201226420.3167@woody.linux-foundation.org>
References: <20080618194917.GC2741@infomag.infomag.iguana.be> <alpine.LFD.1.10.0806181256010.2907@woody.linux-foundation.org> <20080620190538.GA30161@redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 20 Jun 2008, Dave Jones wrote:
> 
> FWIW, we coincidentally got the below oops reported yesterday.
> This was against 2.6.25.4, but this doesn't seem related to the NMI path,
> so probably unfixed ?

This could be fixed by my patch - you're running in 32-bit, so it's using 
the "asmcall" thing in detection.

I committed my first (hackier, but simpler) patch that was tested by some 
people on both 32-bit and apparently 64-bit too. It *may* fix this.

		Linus
