Return-Path: <linux-kernel-owner+w=401wt.eu-S1756406AbYFYDBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbYFYDBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 23:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbYFYDBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 23:01:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751250AbYFYDBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 23:01:23 -0400
Date: Tue, 24 Jun 2008 20:00:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Paul Jackson <pj@sgi.com>, yhlu.kernel@gmail.com,
       akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       steiner@sgi.com, travis@sgi.com, linux-kernel@vger.kernel.org,
       ying.huang@intel.com, andi@firstfloor.org
Subject: Re: [PATCH 4/5 v2] x86 boot: show pfn addresses in hex not decimal
 in some kernel info printks
In-Reply-To: <alpine.LFD.1.10.0806241949030.13106@hp.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0806242000310.13106@hp.linux-foundation.org>
References: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com> <20080622142212.5591.64592.sendpatchset@polaris-admin.engr.sgi.com> <86802c440806221238g78300952t2fc7f406c1842273@mail.gmail.com> <20080623060939.6b6b3183.pj@sgi.com>
 <86802c440806241429s7f5e899dn67d42303247f618@mail.gmail.com> <20080624203252.f932c631.pj@sgi.com> <4861A5DF.5010104@zytor.com> <20080624211711.8c6d5105.pj@sgi.com> <4861AAEF.3020103@zytor.com> <alpine.LFD.1.10.0806241949030.13106@hp.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Jun 2008, Linus Torvalds wrote:
> 
> And yes, to avoid messing with current users, maybe we should only do that 
> with %#p (which I don't think anybody uses right now, although I suspect 
> it actually adds the '0x' you'd like). The '#' thing is, of course, all 
> about 'alternate forms'. But I worry that gcc warns about undefined 
> formatting behavior.

Indeed it does, I just checked. Very irritating.

		Linus
