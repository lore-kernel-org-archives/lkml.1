Return-Path: <linux-kernel-owner+w=401wt.eu-S1760442AbXEJKDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760442AbXEJKDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 06:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbXEJKDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 06:03:14 -0400
Received: from mx1.suse.de ([195.135.220.2]:53327 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069AbXEJKDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 06:03:14 -0400
From: Neil Brown <neilb@suse.de>
To: "Menny Hamburger" <menny@exanet.com>
Date: Thu, 10 May 2007 20:02:37 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17986.60861.587591.548652@notabene.brown>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] NLM program ID for user space NLM server
In-Reply-To: message from Menny Hamburger on Thursday May 10
References: <A6FDE6B975803043804A49F12F49028E0F59C7@hawk.exanet-il.co.il>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday May 10, menny@exanet.com wrote:
> Hi,
> 
> Since the current kernel cannot be compiled with NFS client and without
> lockd, it is not possible to register a user space NLM server
> Without colliding with the kernel service registered in
> .../fs/lockd/lockd.c.

This doesn't make any sense to me at all.
You can certainly have the NFS client compiled and even running
without lockd running (if you mount with "-o nolock") and in that case
you are free you register your owner user-space NLM server (though I'm
not sure what good it would do you).

And if you want to mount an NFS filesystem without "-o nolock", then
you really need the kernel lockd running, or locking will not work.

Can you explain what you are trying to do - I'm curious.

>  
> +#ifndef 
>  #define NLM_PROGRAM		100021
> +#endif

Uhm...  Do you mean

  +#ifndef NLM_PROGRAM

??  Still not sure how that helps.

NeilBrown
