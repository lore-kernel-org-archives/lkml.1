Return-Path: <linux-kernel-owner+w=401wt.eu-S1758901AbYBRLQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901AbYBRLQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 06:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756713AbYBRLQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 06:16:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756151AbYBRLQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 06:16:03 -0500
Subject: Re: [2.6 patch] gfs2/ops_file.c should #include "ops_inode.h"
From: Steven Whitehouse <swhiteho@redhat.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080217081712.GF3848@cs181133002.pp.htv.fi>
References: <20080217081712.GF3848@cs181133002.pp.htv.fi>
Content-Type: text/plain
Organization: Red Hat UK Ltd
Date: Mon, 18 Feb 2008 11:15:24 +0000
Message-Id: <1203333324.9635.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Now in the GFS2 -nmw git tree. Thanks,

Steve.

On Sun, 2008-02-17 at 10:17 +0200, Adrian Bunk wrote:
> Every file should include the headers containing the prototypes for
> its global functions (in this case for gfs2_set_inode_flags()).
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 34f925ebad8d18c4061536e275e33e888f827fd6 diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
> index f4842f2..64fd81c 100644
> --- a/fs/gfs2/ops_file.c
> +++ b/fs/gfs2/ops_file.c
> @@ -39,6 +39,7 @@
>  #include "util.h"
>  #include "eaops.h"
>  #include "ops_address.h"
> +#include "ops_inode.h"
>  
>  /**
>   * gfs2_llseek - seek to a location in a file
> 

