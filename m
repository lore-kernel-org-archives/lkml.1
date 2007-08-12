Return-Path: <linux-kernel-owner+w=401wt.eu-S1765721AbXHLKCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765721AbXHLKCF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 06:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759095AbXHLKBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 06:01:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48990 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754405AbXHLKBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 06:01:35 -0400
From: Andi Kleen <ak@suse.de>
To: discuss@x86-64.org
Subject: Re: [discuss] [PATCH] Fix triplefault on x86-64 bootup
Date: Sun, 12 Aug 2007 11:57:58 +0200
User-Agent: KMail/1.9.1
Cc: Petr Vandrovec <petr@vandrovec.name>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <20070812081252.GA23309@vana.vc.cvut.cz>
In-Reply-To: <20070812081252.GA23309@vana.vc.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708121157.58776.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 August 2007 10:12, Petr Vandrovec wrote:
> Hello,
>   after I upgraded kernel on my box to current git, only thing it did
> was rebooting in a loop.  After some digging I found that it is silly
> to apply alternative to memcpy by using that every same memcpy...


I already have a patch submitted for this, but so far Linus hasn't applied it.
> Sorry if it is known bug, I do not see it reported in my LKML mailbox...

It was posted in my late merge review series a couple of days ago

-Andi
