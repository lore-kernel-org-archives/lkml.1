Return-Path: <linux-kernel-owner+w=401wt.eu-S933464AbXDCI7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933464AbXDCI7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 04:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933567AbXDCI7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 04:59:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:37844 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933464AbXDCI67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 04:58:59 -0400
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, xfs-masters@oss.sgi.com, reiserfs-dev@namesys.com
Subject: Re: [PATCH] Cleanup and kernelify shrinker registration (rc5-mm2)
References: <1175571885.12230.473.camel@localhost.localdomain>
From: Andi Kleen <andi@firstfloor.org>
Date: 03 Apr 2007 11:57:33 +0200
In-Reply-To: <1175571885.12230.473.camel@localhost.localdomain>
Message-ID: <p73lkh9zsoi.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> writes:
> 2) The wrapper code in xfs might no longer be needed.
> 3) The placing in the x86-64 "hot function list" for seems a little
>    unlikely.  Clearly, Andi was testing if anyone was paying attention.

That came from Arjan. The list is likely quite out of date now
because it hasn't been refreshed for some time. Perhaps should
just remove it again -- was never sure it was worth it.

-Andi
