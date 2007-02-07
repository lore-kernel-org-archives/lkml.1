Return-Path: <linux-kernel-owner+w=401wt.eu-S1161164AbXBGKns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161164AbXBGKns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 05:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161170AbXBGKns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 05:43:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161164AbXBGKnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 05:43:47 -0500
Subject: Re: [-mm patch] make gfs2_writepages() static
From: Steven Whitehouse <swhiteho@redhat.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       cluster-devel@redhat.com
In-Reply-To: <20070206221249.GJ27397@stusta.de>
References: <20070129204528.eb8d695e.akpm@osdl.org>
	 <20070206221249.GJ27397@stusta.de>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Wed, 07 Feb 2007 10:50:26 +0000
Message-Id: <1170845426.11001.418.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Now applied to the GFS2 -nmw git tree. Thanks,

Steve.

On Tue, 2007-02-06 at 23:12 +0100, Adrian Bunk wrote:
> On Mon, Jan 29, 2007 at 08:45:28PM -0800, Andrew Morton wrote:
> >...
> > Changes since 2.6.20-rc6-mm2:
> >...
> >  git-gfs2-nmw.patch
> >...
> >  git trees
> >...
> 
> 
> This patch makes the needlessly global gfs2_writepages() static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> --- linux-2.6.20-rc6-mm3/fs/gfs2/ops_address.c.old	2007-02-06 08:30:19.000000000 +0100
> +++ linux-2.6.20-rc6-mm3/fs/gfs2/ops_address.c	2007-02-06 08:30:32.000000000 +0100
> @@ -170,7 +170,8 @@
>   * and write whole extents at once. This is a big reduction in the
>   * number of I/O requests we send and the bmap calls we make in this case.
>   */
> -int gfs2_writepages(struct address_space *mapping, struct writeback_control *wbc)
> +static int gfs2_writepages(struct address_space *mapping,
> +			   struct writeback_control *wbc)
>  {
>  	struct inode *inode = mapping->host;
>  	struct gfs2_inode *ip = GFS2_I(inode);
> 

