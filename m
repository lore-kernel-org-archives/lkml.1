Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbYFYFGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbYFYFGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 01:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbYFYFGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 01:06:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38912 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbYFYFGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 01:06:24 -0400
Message-ID: <4861D230.7040101@zytor.com>
Date: Tue, 24 Jun 2008 22:05:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Paul Jackson <pj@sgi.com>, yhlu.kernel@gmail.com,
       akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       steiner@sgi.com, travis@sgi.com, linux-kernel@vger.kernel.org,
       ying.huang@intel.com, andi@firstfloor.org
Subject: Re: [PATCH 4/5 v2] x86 boot: show pfn addresses in hex not decimal
 in some kernel info printks
References: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com> <20080622142212.5591.64592.sendpatchset@polaris-admin.engr.sgi.com> <86802c440806221238g78300952t2fc7f406c1842273@mail.gmail.com> <20080623060939.6b6b3183.pj@sgi.com> <86802c440806241429s7f5e899dn67d42303247f618@mail.gmail.com> <20080624203252.f932c631.pj@sgi.com> <4861A5DF.5010104@zytor.com> <20080624211711.8c6d5105.pj@sgi.com> <4861AAEF.3020103@zytor.com> <alpine.LFD.1.10.0806241949030.13106@hp.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806241949030.13106@hp.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> And yes, to avoid messing with current users, maybe we should only do that 
> with %#p (which I don't think anybody uses right now, although I suspect 
> it actually adds the '0x' you'd like). The '#' thing is, of course, all 
> about 'alternate forms'. But I worry that gcc warns about undefined 
> formatting behavior.
> 

FWIW, I did a pass over the tree stripping out all the 0x%p's and 
changing the behaviour about a year ago.  It ended up sitting around and 
not be submitted, but I'd be happy to re-do it.

	-hpa
