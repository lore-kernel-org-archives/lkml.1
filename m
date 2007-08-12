Return-Path: <linux-kernel-owner+w=401wt.eu-S932493AbXHLIl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493AbXHLIl1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 04:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756248AbXHLIlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 04:41:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34981 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752943AbXHLIlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 04:41:18 -0400
Date: Sun, 12 Aug 2007 01:40:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Petr Vandrovec <petr@vandrovec.name>
cc: ak@suse.de, discuss@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix triplefault on x86-64 bootup
In-Reply-To: <20070812081252.GA23309@vana.vc.cvut.cz>
Message-ID: <alpine.LFD.0.999.0708120140160.30176@woody.linux-foundation.org>
References: <20070812081252.GA23309@vana.vc.cvut.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 12 Aug 2007, Petr Vandrovec wrote:
>
>   after I upgraded kernel on my box to current git, only thing it did 
> was rebooting in a loop.  After some digging I found that it is silly 
> to apply alternative to memcpy by using that every same memcpy... 
> Sorry if it is known bug, I do not see it reported in my LKML mailbox...

Hmm. Patch looks ok, I just wonder what started triggering this for you?

		Linus
