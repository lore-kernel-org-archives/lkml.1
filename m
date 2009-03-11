Return-Path: <linux-kernel-owner+w=401wt.eu-S1755709AbZCKPOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbZCKPOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 11:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbZCKPOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 11:14:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55920 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755455AbZCKPOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 11:14:15 -0400
Date: Wed, 11 Mar 2009 11:12:51 -0400
From: Jason Baron <jbaron@redhat.com>
To: Greg Banks <gnb@sgi.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
       linux-next@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: driver-core tree build failure
Message-ID: <20090311151251.GA3150@redhat.com>
References: <20090310192440.949884a1.sfr@canb.auug.org.au> <alpine.LRH.2.00.0903101423200.25436@vixen.sonytel.be> <20090310145311.6bf9d9e9@skybase> <alpine.LRH.2.00.0903101626450.25436@vixen.sonytel.be> <20090310170841.2257de86@skybase> <20090310200200.GB3091@redhat.com> <49B78D60.2070402@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B78D60.2070402@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 09:07:28PM +1100, Greg Banks wrote:
> 
> I think this patch does the same thing more cleanly.
> 
> When CONFIG_DYNAMIC_DEBUG is enabled, allow callers of pr_debug()
> to provide their own definition of pr_fmt() even if that definition
> uses tricks like
> 
> #define pr_fmt(fmt) "%s:" fmt, __func__
> 

patch looks good. I agree its simpler than what I proposed. However, I
don't think we want to add pr_fmt() in the dynamic_dev_dbg() path, since
dev_dbg() isn't doing that to start with. Other than that, I ack it.

thanks,

-Jason

