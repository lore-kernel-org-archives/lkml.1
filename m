Return-Path: <linux-kernel-owner+w=401wt.eu-S1765882AbYBMWdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765882AbYBMWdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757290AbYBMWd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:33:29 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42293
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751054AbYBMWd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:33:27 -0500
Date: Wed, 13 Feb 2008 14:33:59 -0800 (PST)
Message-Id: <20080213.143359.258873954.davem@davemloft.net>
To: galak@kernel.crashing.org
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: [PATCH] [POWERPC] Fix initial lmb add region with a non-zero
 base
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0802130719330.14428@blarg.am.freescale.net>
References: <Pine.LNX.4.64.0802130719330.14428@blarg.am.freescale.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kumar Gala <galak@kernel.crashing.org>
Date: Wed, 13 Feb 2008 07:37:27 -0600 (CST)

> If we add to an empty lmb region with a non-zero base we will not coalesce
> the number of regions done to one.  This causes problems on ppc32 for the
> memory region as its assumed to only have one region.
> 
> We can fix this be easily specially casing the initial add to just replace
> the dummy region.
> 
> ---
> 
> Posting this since Dave's looking a pulling the lmb code out into lib/ and
> sharing it between powerpc and sparc.
> 
> (this is my git tree git.kernel.org:/pub/scm/linux/kernel/git/galak/powerpc.git)

I noticed this issue when I use lmb on sparc64 and I intended to bring
it up eventually.  Thanks for fixing it!
