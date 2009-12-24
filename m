Return-Path: <linux-kernel-owner+w=401wt.eu-S1754357AbZLXGIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbZLXGIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 01:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753861AbZLXGIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 01:08:16 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:49919 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbZLXGIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 01:08:15 -0500
Date: Thu, 24 Dec 2009 15:07:59 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       kdb@oss.sgi.com, mingo@elte.hu
Subject: Re: [PATCH 08/37] kgdb,sh: update superh kgdb exception handling
Message-ID: <20091224060759.GE28878@linux-sh.org>
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com> <1261603190-5036-2-git-send-email-jason.wessel@windriver.com> <1261603190-5036-3-git-send-email-jason.wessel@windriver.com> <1261603190-5036-4-git-send-email-jason.wessel@windriver.com> <1261603190-5036-5-git-send-email-jason.wessel@windriver.com> <1261603190-5036-6-git-send-email-jason.wessel@windriver.com> <1261603190-5036-7-git-send-email-jason.wessel@windriver.com> <1261603190-5036-8-git-send-email-jason.wessel@windriver.com> <1261603190-5036-9-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261603190-5036-9-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 03:19:21PM -0600, Jason Wessel wrote:
> Implement kgdb_arch_pc() which adjusts the pc if it needs to be
> adjusted after a software breakpoint trap.
> 
> Implement kgdb_arch_set_pc() which is a new required function in the
> kgdb debug core.
> 
> When processing a single step return zero in the error exception field
> so that the debug core can distinguish between a single step trap and
> a breakpoint trap generically.
> 
> CC: Paul Mundt <lethal@linux-sh.org>
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> ---
>  arch/sh/kernel/kgdb.c |   14 +++++++++++++-
>  1 files changed, 13 insertions(+), 1 deletions(-)
> 
Acked-by: Paul Mundt <lethal@linux-sh.org>
