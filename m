Return-Path: <linux-kernel-owner+w=401wt.eu-S934888AbXHLNBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934888AbXHLNBq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 09:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765418AbXHLNBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 09:01:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60515 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763035AbXHLNBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 09:01:38 -0400
To: Petr Vandrovec <petr@vandrovec.name>
Cc: discuss@x86-64.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Please remove ab144f5ec64c42218a555ec1dbde6b60cf2982d6 was Re: [discuss] [PATCH] Fix triplefault on x86-64 bootup
References: <20070812081252.GA23309@vana.vc.cvut.cz>
	<200708121209.40995.ak@suse.de> <46BEE427.3020904@vandrovec.name>
From: Andi Kleen <andi@firstfloor.org>
Date: 12 Aug 2007 15:55:50 +0200
In-Reply-To: <46BEE427.3020904@vandrovec.name>
Message-ID: <p731we8kgbd.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Petr Vandrovec <petr@vandrovec.name> writes:

> Andi Kleen wrote:
> > On Sunday 12 August 2007 10:12, Petr Vandrovec wrote:
> >> Hello,
> >>   after I upgraded kernel on my box to current git, only thing it did
> >> was rebooting in a loop.  After some digging I found that it is silly
> >> to apply alternative to memcpy by using that every same memcpy...
> >> Sorry if it is known bug, I do not see it reported in my LKML mailbox...
> > Ok Linus already applied your patch. Even though it's a really bad
> > fragile hack, not better than the old bug.
> > Petr are you double sure you really tested with
> > ab144f5ec64c42218a555ec1dbde6b60cf2982d6
> > already applied? I bet not -- it is the symptom exactly fixed by this patch
> 
> I'm quite sure that this patch is in my tree, as I have that "u8
> *instr = a->instr;" in apply_alternatives, and it seems that this one
> was added by checkin you mention...  My tree was synced up to:

Can you double check? I have a hard time believing it.

> It does not actually change two bytes - it changes two bytes now
> because alternative is two bytes long - it makes no sense to replace
> whole function with NOPs - it is necessary when you fall through that

It saves the jump. Admittedly not a big advantage.

-Andi
