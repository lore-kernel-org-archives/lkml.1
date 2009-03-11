Return-Path: <linux-kernel-owner+w=401wt.eu-S1752831AbZCKPzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbZCKPzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 11:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbZCKPzC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 11:55:02 -0400
Received: from ns1.suse.de ([195.135.220.2]:59104 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107AbZCKPzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 11:55:01 -0400
Date: Wed, 11 Mar 2009 16:54:57 +0100
From: Jan Kara <jack@suse.cz>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] udf: fix novrs mount option
Message-ID: <20090311155457.GG24590@duck.suse.cz>
References: <49B0DBF1.1060800@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B0DBF1.1060800@ladisch.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 06-03-09 09:16:49, Clemens Ladisch wrote:
> The novrs mount option was broken due to a missing break.
> 
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
> 
> --- linux-2.6.orig/fs/udf/super.c
> +++ linux-2.6/fs/udf/super.c
> @@ -428,6 +428,7 @@ static int udf_parse_options(char *optio
>  		switch (token) {
>  		case Opt_novrs:
>  			uopt->novrs = 1;
> +			break;
>  		case Opt_bs:
>  			if (match_int(&args[0], &option))
>  				return 0;
  Thanks for the patch. Merged into UDF tree.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
