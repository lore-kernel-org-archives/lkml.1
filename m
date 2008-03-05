Return-Path: <linux-kernel-owner+w=401wt.eu-S1762588AbYCEVmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762588AbYCEVmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbYCEVmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:42:36 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52445 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755652AbYCEVmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:42:35 -0500
Subject: Re: [PATCH 5/9] jfs: replace __inline with inline
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1204679838.5698.71.camel@brick>
References: <1204679838.5698.71.camel@brick>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 21:42:29 +0000
Message-Id: <1204753349.8446.25.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've added this to the jfs git tree.

Thanks,
Shaggy

On Tue, 2008-03-04 at 17:17 -0800, Harvey Harrison wrote:
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  fs/jfs/jfs_dmap.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/jfs/jfs_dmap.h b/fs/jfs/jfs_dmap.h
> index 11e6d47..1a6eb41 100644
> --- a/fs/jfs/jfs_dmap.h
> +++ b/fs/jfs/jfs_dmap.h
> @@ -61,7 +61,7 @@
>   * determine the maximum free string for four (lower level) nodes
>   * of the tree.
>   */
> -static __inline signed char TREEMAX(signed char *cp)
> +static inline signed char TREEMAX(signed char *cp)
>  {
>  	signed char tmp1, tmp2;
>  
-- 
David Kleikamp
IBM Linux Technology Center

