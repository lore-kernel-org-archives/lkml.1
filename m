Return-Path: <linux-kernel-owner+w=401wt.eu-S1763985AbZFLJxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763985AbZFLJxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 05:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbZFLJxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 05:53:34 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:54472 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751740AbZFLJxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 05:53:33 -0400
Subject: Re: kmemleak: Pull request
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.01.0906111420430.3535@localhost.localdomain>
References: <1244737527.13225.69.camel@pc1117.cambridge.arm.com>
	 <alpine.LFD.2.01.0906111420430.3535@localhost.localdomain>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 12 Jun 2009 10:53:26 +0100
Message-Id: <1244800406.26670.29.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Jun 2009 09:53:27.0530 (UTC) FILETIME=[A250A4A0:01C9EB43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-11 at 14:21 -0700, Linus Torvalds wrote:
> 
> On Thu, 11 Jun 2009, Catalin Marinas wrote:
> > 
> > Please consider pulling the kmemleak patches from the branch detailed
> > below.
> 
> Ok, I got conflicts with the slab/earlyboot changes, but they looked 
> resolvable. I haven't tested the merge though, so please do give it a good 
> check.

I tested it with both slab and slub allocators and seems alright (and
found a possible leak in tty_ldisc.c). I'll give it a try with slob as
well.

There are two more trivial patches to merge. I'll send them as replies
to this mail but you can pull them directly from the same for-linus
branch:


The following changes since commit 8ebf975608aaebd7feb33d77f07ba21a6380e086:
  Randy Dunlap (1):
        block: fix kernel-doc in recent block/ changes

are available in the git repository at:

  git://linux-arm.org/linux-2.6.git for-linus

Catalin Marinas (2):
      kmemleak: Remove the kmemleak.h include in drivers/char/vt.c
      kmemleak: Add more info to the MAINTAINERS entry

 MAINTAINERS       |   16 ++++++++++------
 drivers/char/vt.c |    1 -
 2 files changed, 10 insertions(+), 7 deletions(-)


Thanks.

-- 
Catalin

