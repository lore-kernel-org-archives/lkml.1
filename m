Return-Path: <linux-kernel-owner+w=401wt.eu-S1752309AbXA0SBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbXA0SBe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 13:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbXA0SBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 13:01:34 -0500
Received: from smtp.osdl.org ([65.172.181.24]:58354 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbXA0SBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 13:01:33 -0500
Date: Sat, 27 Jan 2007 09:58:08 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
cc: =?ISO-8859-1?Q?Malte_Schr=C3=B6der?= <MalteSch@gmx.de>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Vladimir V. Saveliev" <vs@namesys.com>, reiserfs-dev@namesys.com
Subject: Re: 2.6.20-rc6: known unfixed regressions (part 2)
In-Reply-To: <20070127172801.GK6017@stusta.de>
Message-ID: <Pine.LNX.4.64.0701270956420.25027@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
 <20070126181132.GN17836@stusta.de> <200701261916.29805.MalteSch@gmx.de>
 <20070127172801.GK6017@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 27 Jan 2007, Adrian Bunk wrote:
> 
> Unless I misunderstand this issue, we want this fixed before 2.6.20 
> because otherwise many people might see this BUG message.

The warnign was removed for other reasons, I'll re-instate it after 2.6.20 
has been released so that we can resolve all filesystem things (as it is, 
right now, it's not any worse than it ever has been, and the kernel will 
shut up about filesystems doing something strange).

But I think the Reiserfs problem already got fixed, and wouldn't warn any 
more even if the WARN_ON() was still there..

		Linus
