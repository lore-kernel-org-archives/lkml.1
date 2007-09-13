Return-Path: <linux-kernel-owner+w=401wt.eu-S1758576AbXIMPdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576AbXIMPdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 11:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754500AbXIMPdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 11:33:31 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:48314 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbXIMPda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 11:33:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lWT4tOX9Z3K2qM2X+ITdX2ZOc++RrHv1eH8b/JKYS8+lntwkY/bDRV0Rg7O1NpdIDdgjjPwfdtZ8WLWtPSYuKArtx/ErdR7cIXG/0fwGV3vACMIIWzYX5M4eaFj3mz41JgKwG72VUbgpz1jn335kYexOq4NxW52vwBzckzucWJY=
Message-ID: <8bd0f97a0709130833g7873ed03m2eff4318a0e4a3e2@mail.gmail.com>
Date: Thu, 13 Sep 2007 11:33:02 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Andy Whitcroft" <apw@shadowen.org>
Subject: Re: [patch] add some Blackfin specific checks to checkpatch.pl
Cc: "Mike Frysinger" <vapier@gentoo.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, bryan.wu@analog.com
In-Reply-To: <20070913115521.GB5146@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708211829.59975.vapier@gentoo.org>
	 <20070913115521.GB5146@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/13/07, Andy Whitcroft <apw@shadowen.org> wrote:
> On Tue, Aug 21, 2007 at 06:29:59PM -0400, Mike Frysinger wrote:
> > Check for a few common errors in Blackfin-specific code wrt MMR loading in
> > assembly and doing core/system syncs.
>
> If we are going to pull arch specific things into checkpatch I think we
> need to make sure we are pretty specific about where we apply them.  I
> am assuming these checks only make sense againt some files in the arch
> tree?

ive restricted the .S check to arch/blackfin/, but the other check
should be run on all .c files since Blackfin drivers may live anywhere
in the tree, not just in arch/ ... i really doubt that'd be a problem
unless another architecture starts implementing functions with
"__builtin_bfin_ssync" in its name ...

side note, Joe pointed out that arch/blackfin regex should be m@...@, not s@...@
-mike
