Return-Path: <linux-kernel-owner+w=401wt.eu-S1757860AbXKHBKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860AbXKHBKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 20:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755254AbXKHBKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 20:10:37 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:52070 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754583AbXKHBKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 20:10:37 -0500
Date: Thu, 8 Nov 2007 00:54:31 +0100
From: Adrian Bunk <bunk@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-am33-list@redhat.com, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 1/2] Suppress A.OUT library support in ELF binfmt if
	!CONFIG_BINFMT_AOUT [try #3]
Message-ID: <20071107235431.GC26163@stusta.de>
References: <20071107174323.31820.65054.stgit@warthog.procyon.org.uk> <20071107174328.31820.62935.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071107174328.31820.62935.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 05:43:28PM +0000, David Howells wrote:

> Suppress A.OUT library support in ELF binfmt if CONFIG_BINFMT_AOUT is not set.
> 
> Not all architectures support the A.OUT binfmt, so the ELF binfmt should not
> be permitted to go looking for A.OUT libraries to load in such a case.
>...

The a.out interpreter support for ELF executables is already scheduled
for being completely removed in 2.6.25.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

