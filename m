Return-Path: <linux-kernel-owner+w=401wt.eu-S1161151AbXBAA6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161151AbXBAA6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 19:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161149AbXBAA6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 19:58:42 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34488 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161151AbXBAA6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 19:58:41 -0500
Date: Wed, 31 Jan 2007 16:54:57 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: =?ISO-8859-1?Q?Pawe=C5_Sikora?= <pluto@agmk.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Martin Peschke <mp3@de.ibm.com>, Andrew Morton <akpm@osdl.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: Linux 2.6.20-rc7
In-Reply-To: <45C137F4.90303@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0701311653040.3632@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org>
 <45C05150.6000802@agmk.net> <Pine.LNX.4.64.0701310748450.3632@woody.linux-foundation.org>
 <200702010037.48472.pluto@agmk.net> <Pine.LNX.4.64.0701311609210.3632@woody.linux-foundation.org>
 <45C137F4.90303@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 Feb 2007, Nick Piggin wrote:
> 
> We could make them both unsigned, and _add_ everything to min rather than
> subtracting from free_pages?

Yeah, that's the right thing to do, probably. However, since we do that 
"min >>=1" thing, we'd have to do that to a separate "correction" factor 
(also unsigned).

No worth it for 2.6.20. I just reverted it. But feel free to send the 
fixed/updated micro-optimization after 2.6.20 has been released..

		Linus
