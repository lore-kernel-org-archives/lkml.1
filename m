Return-Path: <linux-kernel-owner+w=401wt.eu-S1756636AbZCENn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbZCENn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:43:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756144AbZCENjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:39:24 -0500
Received: from verein.lst.de ([213.95.11.210]:46036 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755428AbZCENjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:39:23 -0500
Date: Thu, 5 Mar 2009 14:39:17 +0100
From: Christoph Hellwig <hch@lst.de>
To: Hannes Eder <hannes@hanneseder.net>
Cc: Felix Blyakher <felixb@sgi.com>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] xfs: include header files for prototypes
Message-ID: <20090305133917.GC14854@lst.de>
References: <20090304183136.525.13769.stgit@f10box.hanneseder.net> <20090304183418.525.22262.stgit@f10box.hanneseder.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090304183418.525.22262.stgit@f10box.hanneseder.net>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

looks good, except for a tiny nit-pick:

> +++ b/fs/xfs/support/debug.c
> @@ -19,6 +19,7 @@
>  #include "debug.h"
>  
>  /* xfs_mount.h drags a lot of crap in, sorry.. */
> +#include "xfs_error.h"
>  #include "xfs_sb.h"
>  #include "xfs_inum.h"
>  #include "xfs_ag.h"

as xfs_mount.h doesn't require xfs_error.h it should be included 
above that comment.
