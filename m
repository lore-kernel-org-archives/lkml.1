Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbXE3BFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbXE3BFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 21:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbXE3BEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 21:04:48 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752441AbXE3BEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 21:04:47 -0400
Date: Tue, 29 May 2007 18:04:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bernd Schmidt <bernds_cb1@t-online.de>
cc: Bryan Wu <bryan.wu@analog.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/20] Blackfin update for 2.6.22-rc3
In-Reply-To: <465CB7CF.2060509@t-online.de>
Message-ID: <alpine.LFD.0.98.0705291759230.26602@woody.linux-foundation.org>
References: <11803414753217-git-send-email-bryan.wu@analog.com>
 <alpine.LFD.0.98.0705291356290.26602@woody.linux-foundation.org>
 <465CB7CF.2060509@t-online.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 May 2007, Bernd Schmidt wrote:
> 
> The binfmt_flat patch also touches other nommu architectures.  Do you
> want these kinds of patches (which aren't just Blackfin-specific)
> separately as they come up?

Let's take it case by case. I really have no problem with architecture- 
specific git trees occasionally touching generic code, but I usually want 
an explanation for _why_ it ends up touching some file that somebody else 
might care about (not so much because I necessarily care deeply, but so 
that I can keep up with changes, so that if somebody then complains, I 
know what they are complaining about!)

For example, what's good to do is to just give me a diffstat of the whole 
thing, and then for generic code, perhaps show the whole diff along with 
the explanation.

And if the diff is big, yes, then we probably need to handle it 
separately, but usually the things tend to be a few lines of "add support 
for this architecture to this piece of code that hasn't been abstracted 
out enough yet".

To make a long story short: no real hard rules. It can be a good idea to 
start out extra careful, and once both sides get more used to each other, 
we can loosen the rules.

		Linus
