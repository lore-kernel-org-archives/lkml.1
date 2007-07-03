Return-Path: <linux-kernel-owner+w=401wt.eu-S1762395AbXGCVht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762395AbXGCVht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761872AbXGCVh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:37:27 -0400
Received: from mail.fieldses.org ([66.93.2.214]:43828 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761500AbXGCVh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:37:26 -0400
Date: Tue, 3 Jul 2007 17:37:22 -0400
To: Mingming Cao <cmm@us.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
Subject: Re: [EXT4 set 4][PATCH 2/5] i_version: Add hi 32 bit inode version on ext4 on-disk inode
Message-ID: <20070703213722.GZ14074@fieldses.org>
References: <1183275436.4010.127.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183275436.4010.127.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2007 at 03:37:16AM -0400, Mingming Cao wrote:
> This patch adds a 32-bit i_version_hi field to ext4_inode, which can be used for 64-bit inode versions. This field will store the higher 32 bits of the version, while Jean Noel's patch has added support to store the lower 32-bits in osd1.linux1.l_i_version.
> 

Sorry, I'm a little lost--where's that earlier patch, and exactly what
tree should this patch series apply to?

--b.

> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
> Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
> ---
> Index: linux-2.6.21/include/linux/ext4_fs.h
> ===================================================================
> --- linux-2.6.21.orig/include/linux/ext4_fs.h
> +++ linux-2.6.21/include/linux/ext4_fs.h
> @@ -342,6 +342,7 @@ struct ext4_inode {
>  	__le32  i_atime_extra;  /* extra Access time      (nsec << 2 | epoch) */
>  	__le32  i_crtime;       /* File Creation time */
>  	__le32  i_crtime_extra; /* extra FileCreationtime (nsec << 2 | epoch) */
> +	__le32	i_version_hi;	/* high 32 bits for 64-bit version */
>  };
> 
>  #define i_size_high	i_dir_acl
> 
> 
> _______________________________________________
> NFSv4 mailing list
> NFSv4@linux-nfs.org
> http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4
