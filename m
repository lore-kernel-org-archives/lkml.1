Return-Path: <linux-kernel-owner+w=401wt.eu-S1757367AbYHNAVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbYHNAVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 20:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756254AbYHNAVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 20:21:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44873
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753564AbYHNAVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 20:21:12 -0400
Date: Wed, 13 Aug 2008 17:21:13 -0700 (PDT)
Message-Id: <20080813.172113.161885391.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080813.164520.86944543.davem@davemloft.net>
References: <20080813.164520.86944543.davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 13 Aug 2008 16:45:20 -0700 (PDT)

> 3) Implement IRQ stacks to deal with very real deep stack code path
>    situations, as reported by Mikulas Patocka.  Also, fix a recursion
>    bug in stack overflow detection.

While further testing I noticed a bug which I've pushed into the
tree, please repull to fetch it if you haven't already, thanks!

The following changes since commit 4f70f7a91bffdcc39f088748dc678953eb9a3fbd:
  David S. Miller (1):
        sparc64: Implement IRQ stacks.

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (1):
      sparc64: Handle stack trace attempts before irqstacks are setup.

 arch/sparc64/kernel/kstack.h     |   38 ++++++++++++++++++++------------------
 arch/sparc64/kernel/stacktrace.c |    3 +--
 2 files changed, 21 insertions(+), 20 deletions(-)
