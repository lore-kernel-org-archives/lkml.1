Return-Path: <linux-kernel-owner+w=401wt.eu-S1759647AbXIYD7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759647AbXIYD7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 23:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756102AbXIYD7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 23:59:03 -0400
Received: from gate.crashing.org ([63.228.1.57]:40802 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758934AbXIYD7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 23:59:01 -0400
Subject: Re: [PATCH 1/2] powerpc: ptrace CHECK_FULL_REGS
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Roland McGrath <roland@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       David Woodhouse <dwmw2@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070925005945.02E924D04B7@magilla.localdomain>
References: <20070924235052.5AFC24D04B7@magilla.localdomain>
	 <1190680406.12382.9.camel@localhost.localdomain>
	 <20070925005945.02E924D04B7@magilla.localdomain>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 13:58:46 +1000
Message-Id: <1190692726.31978.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-09-24 at 17:59 -0700, Roland McGrath wrote:
> > Yup, I think I ditched most of them.. for some reason I decided it
> > couldn't happen, but maybe I'm wrong ?
> 
> Well, it's a BUG_ON.  It's supposed to be for something that "can't happen".
> That's why it's a sanity check, not a wild assertion. ;-)
> 
> The 2/2 patch is an example of a bug that CHECK_FULL_REGS catches.
> In the status quo, using PTRACE_PEEKUSR in a bug case crashes while using
> PTRACE_GETREGS in the same place might get bogus data.  (In the actual bug
> thus found, the data is not bogus and only the bit that FULL_REGS checks is.)

Fair enough.

Ben.


