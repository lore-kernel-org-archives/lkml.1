Return-Path: <linux-kernel-owner+w=401wt.eu-S1759627AbXH2NFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627AbXH2NFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 09:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756377AbXH2NFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 09:05:25 -0400
Received: from kanga.kvack.org ([66.96.29.28]:36004 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755617AbXH2NFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 09:05:24 -0400
Date: Wed, 29 Aug 2007 08:22:43 -0400
From: Marcelo Tosatti <marcelo@kvack.org>
To: Jochen Friedrich <jochen@scram.de>, Paul Mackerras <paulus@samba.org>
Cc: linuxppc-embedded@ozlabs.org, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <marcelo@kvack.org>
Subject: Re: [PATCH] ppc32/8xx: Fix r3 trashing due to 8MB TLB page instantiation
Message-ID: <20070829122243.GA21150@dmt>
References: <46D40510.3060805@scram.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D40510.3060805@scram.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please apply. 

On Tue, Aug 28, 2007 at 01:20:48PM +0200, Jochen Friedrich wrote:
> Instantiation of 8MB pages on the TLB cache for the kernel static
> mapping trashes r3 register on !CONFIG_8xx_CPU6 configurations.
> This ensures r3 gets saved and restored.
> 
> This has been posted to linuxppc-embedded by Marcelo Tosatti
> <marcelo@kvack.org>, but only an incomplete version of the patch
> has been applied in c51e078f82096a7d35ac8ec2416272e843a0e1c4.
> This patch adds the rest of the fix.
> 
> Signed-off-by: Jochen Friedrich <jochen@scram.de>
> ---
>  arch/ppc/kernel/head_8xx.S |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> This can be pulled from git://git.bocc.de/dbox2.git ppc-fixes


