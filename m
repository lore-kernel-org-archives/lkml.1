Return-Path: <linux-kernel-owner+w=401wt.eu-S1760886AbYGQQCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760886AbYGQQCc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 12:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760710AbYGQQB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 12:01:59 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:41390 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760997AbYGQQB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 12:01:58 -0400
Message-ID: <487F6CE8.8090203@freescale.com>
Date: Thu, 17 Jul 2008 10:01:44 -0600
From: John Rigby <jrigby@freescale.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080505)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: petkovbb@googlemail.com, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] Fix collateral damage to top level Makefile
References: <20080717070549.30755.13083.stgit@trillian.secretlab.ca>
In-Reply-To: <20080717070549.30755.13083.stgit@trillian.secretlab.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant,

I owe you on this one.  Sorry.

John

Grant Likely wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
>
> The patch named "powerpc/mpc5121: Add clock driver", also contained
> an unrelated and bogus change to the top-level makefile.  This patch
> backs out the bad bit.
>
> SHA1 of offending patch: 137e95906e294913fab02162e8a1948ade49acb5)
>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>
> If the maintainer who picked up this patch (Grant Likely) had done
> his job, this cack-up never would have happened.  Why do we still
> have to deal with such sloppy individuals?
>
> Ben/Linus;  I assume one of you will want to pick this up soonish?
> Otherwise, I'll add it to my tree and it will be part of my next
> pull request.
>
> g.
>
>  Makefile |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index 1564577..6192922 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,4 +1,3 @@
> -FRED=42
>  VERSION = 2
>  PATCHLEVEL = 6
>  SUBLEVEL = 26
>
>
>   

