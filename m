Return-Path: <linux-kernel-owner+w=401wt.eu-S1030760AbXAZFl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030760AbXAZFl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 00:41:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030772AbXAZFl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 00:41:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030760AbXAZFlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 00:41:55 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] x86_64: fix put_user for 64-bit constant
In-Reply-To: Linus Torvalds's message of  Thursday, 25 January 2007 17:49:44 -0800 <Pine.LNX.4.64.0701251747530.25027@woody.linux-foundation.org>
X-Fcc: ~/Mail/linus
X-Zippy-Says: Place me on a BUFFER counter while you BELITTLE several BELLHOPS in
   the Trianon Room!!  Let me one of your SUBSIDIARIES!
Message-Id: <20070126054119.A0D12180051@magilla.sf.frob.com>
Date: Thu, 25 Jan 2007 21:41:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not aware of any code in the tree triggering it.  We copied some of the
uaccess.h macro guts into macros used in systemtap, and there we hit an
instance of someone producing code that used a large constant and hit the
problem.  Since I noticed the kernel code still had the same bug, I was
just being proactive in propagating the fix back.


Thanks,
Roland
