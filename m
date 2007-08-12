Return-Path: <linux-kernel-owner+w=401wt.eu-S933276AbXHLKBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276AbXHLKBo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 06:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757744AbXHLKBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 06:01:36 -0400
Received: from ns.suse.de ([195.135.220.2]:53652 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336AbXHLKBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 06:01:35 -0400
From: Andi Kleen <ak@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Fix triplefault on x86-64 bootup
Date: Sun, 12 Aug 2007 11:59:39 +0200
User-Agent: KMail/1.9.1
Cc: Petr Vandrovec <petr@vandrovec.name>, discuss@x86-64.org,
       linux-kernel@vger.kernel.org
References: <20070812081252.GA23309@vana.vc.cvut.cz> <alpine.LFD.0.999.0708120140160.30176@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0708120140160.30176@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708121159.40211.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 August 2007 10:40, Linus Torvalds wrote:
> On Sun, 12 Aug 2007, Petr Vandrovec wrote:
> >   after I upgraded kernel on my box to current git, only thing it did
> > was rebooting in a loop.  After some digging I found that it is silly
> > to apply alternative to memcpy by using that every same memcpy...
> > Sorry if it is known bug, I do not see it reported in my LKML mailbox...
>
> Hmm. Patch looks ok, I just wonder what started triggering this for you?

Can you please just apply the patch series please? 
This one is fixed in  "Make patching more robust, fix paravirt issue"


-Andi
