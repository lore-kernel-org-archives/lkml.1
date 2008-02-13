Return-Path: <linux-kernel-owner+w=401wt.eu-S932162AbYBMK7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162AbYBMK7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 05:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757850AbYBMK71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 05:59:27 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:36875 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755509AbYBMK7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 05:59:25 -0500
X-Greylist: delayed 616 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2008 05:59:25 EST
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
From: Catalin Marinas <catalin.marinas@arm.com>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <greg@kroah.com>,
       David Miller <davem@davemloft.net>, jeff@garzik.org,
       arjan@infradead.org, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20080213021650.GA12785@mit.edu>
References: <20080211211751.3e265754@laptopd505.fenrus.org>
	 <20080211.221126.230471463.davem@davemloft.net>
	 <47B1CB08.4020101@garzik.org>
	 <20080212.155853.193190548.davem@davemloft.net>
	 <20080213002948.GA8899@kroah.com>
	 <alpine.LFD.1.00.0802121645320.2920@woody.linux-foundation.org>
	 <20080213021650.GA12785@mit.edu>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 13 Feb 2008 10:58:35 +0000
Message-Id: <1202900315.21202.20.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Feb 2008 10:58:31.0309 (UTC) FILETIME=[5ECD4BD0:01C86E2F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-12 at 21:16 -0500, Theodore Tso wrote:
> I've never been very happy with stgit because of past experiences
> which has scarred me when it got get confused and lost my entire patch
> series (this was before git reflogs, so recovery was.... interesting).

It got much better now :-). We are even working on transactions support
and, if something fails, it restores the state of the stack.

> There's always been something deeply comforting about having the ASCII
> patch series since it's easy to back it up and know you're in no
> danger of losing everything in case of a bug.  

There is "stg export" which could be made to export a patch
automatically at every change.

> The other advantage of storing the patch stack as a an ASCII quilt
> series is we have a history of changes of the patches, which we don't
> necessarily have if you just use stgit to rewrite the patch.  

As I said in a different e-mail, we got patch history tracking in StGIT.
You can even annotate specific changes.

For editing, there is "stg edit [--diff]" which allows both description
and patch changes.

However, the StGIT approach is not fully suited for multiple developers
sharing the same set of patches, especially if they are allowed to
modify the same patches. For this kind of workflow, you can export the
series and add the patches to a separate shared repository. StGIT has a
"sync" command to synchronise changes to patches in different series
(either stored as quilt series or in a different branch).

-- 
Catalin

