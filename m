Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbXJWP2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbXJWP2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 11:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbXJWP1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 11:27:54 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:38263 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbXJWP1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 11:27:52 -0400
Date: Tue, 23 Oct 2007 10:27:40 -0500
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Jens@secretlab.ca,
       "Axboe <jens.axboe"@oracle.com, linuxppc-dev@ozlabs.org,
       Linus Torvalds <torvalds@linux-foundation.org>, paulus@samba.org
Subject: Re: [PATCH] Bugfix to commit
 18dabf473e15850c0dbc8ff13ac1e2806d542c15
Message-ID: <20071023102740.72b372ae@weaponx.rchland.ibm.com>
In-Reply-To: <20071023151929.12090.3835.stgit@trillian.cg.shawcable.net>
References: <20071023151929.12090.3835.stgit@trillian.cg.shawcable.net>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; powerpc-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007 09:20:25 -0600
Grant Likely <grant.likely@secretlab.ca> wrote:

> From: Grant Likely <grant.likely@secretlab.ca>
> 
> Fixup for commit 18dabf473e15850c0dbc8ff13ac1e2806d542c15.  Changes to
> dma_map_sg where done in asm-x86/dma-mapping_32.h, but were not mirrored
> in include/asm-powerpc/dma-mapping.h
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
> 
> Linus, I cannot build an arch/powerpc kernel without this patch.

Olof Johansson already sent a patch out for this that had some other
fixes in it.  I think Jens already applied it to his tree.

josh
