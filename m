Return-Path: <linux-kernel-owner+w=401wt.eu-S1758648AbYBMPAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbYBMPAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbYBMPAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:00:23 -0500
Received: from jdl.com ([208.123.74.7]:53732 "EHLO jdl.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023AbYBMPAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:00:22 -0500
X-Greylist: delayed 2399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2008 10:00:22 EST
To: Kumar Gala <galak@kernel.crashing.org>
cc: linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [POWERPC] Fix initial lmb add region with a non-zero base 
In-Reply-To: Your message of "Wed, 13 Feb 2008 07:37:27 CST."
             <Pine.LNX.4.64.0802130719330.14428@blarg.am.freescale.net> 
References: <Pine.LNX.4.64.0802130719330.14428@blarg.am.freescale.net> 
Date: Wed, 13 Feb 2008 08:20:07 -0600
From: Jon Loeliger <jdl@jdl.com>
Message-Id: <E1JPIT1-0001ke-GR@jdl.com>
X-Spam-Score: -2.6 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So, like, the other day Kumar Gala mumbled:
> If we add to an empty lmb region with a non-zero base we will not coalesce
> the number of regions done to one.  This causes problems on ppc32 for the

s/done/down

> memory region as its assumed to only have one region.
> 
> We can fix this be easily specially casing the initial add to just replace
> the dummy region.
> 
> ---
>
> Posting this since Dave's looking a pulling the lmb code out into lib/ and
> sharing it between powerpc and sparc.

Did you want to S-o-b: this patch?  Or was this just informational?

Thanks,
jdl
