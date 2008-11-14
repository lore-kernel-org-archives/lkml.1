Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbYKNDSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbYKNDSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 22:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYKNDSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 22:18:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751143AbYKNDSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 22:18:32 -0500
Date: Thu, 13 Nov 2008 19:18:11 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] x86: optimise page fault path a little
In-Reply-To: <20081114024347.GB24414@wotan.suse.de>
Message-ID: <alpine.LFD.2.00.0811131916530.3468@nehalem.linux-foundation.org>
References: <20081113072821.GB2946@wotan.suse.de> <alpine.LFD.2.00.0811130749440.3468@nehalem.linux-foundation.org> <20081114015817.GC5063@wotan.suse.de> <alpine.LFD.2.00.0811131803300.3468@nehalem.linux-foundation.org>
 <20081114024347.GB24414@wotan.suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 14 Nov 2008, Nick Piggin wrote:
> 
> I don't exactly know what you mean by random micro-optimization. It is
> what it is. I like counting cachelines and branches and I thought you
> did as well.

You're missing the point.

If you spent a bit more time on it, it would be a cleanup too, and we 
wouldn't need this discussion.

As it is, it's a wash. At which point I'd simply rather not touch the 
code. 

You can have your cake and eat it too, and I tried to explain how. And I 
don't understand why you argue against it.

		Linus
