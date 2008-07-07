Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbYGGK5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbYGGK5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 06:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbYGGK5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 06:57:23 -0400
Received: from fogou.chygwyn.com ([195.171.2.24]:44957 "EHLO fogou.chygwyn.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886AbYGGK5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 06:57:23 -0400
X-Greylist: delayed 1691 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2008 06:57:22 EDT
Subject: Re: [PATCH]remove_declaration
From: Steven Whitehouse <steve@chygwyn.com>
To: Li Xiaodong <lixd@cn.fujitsu.com>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>
In-Reply-To: <AEFD1C75C2D6496EB4B19CE6B33656F2@fujitsulixd>
References: <AEFD1C75C2D6496EB4B19CE6B33656F2@fujitsulixd>
Content-Type: text/plain
Organization: ChyGwyn Limited (Registered in England and Wales, No.
	03887683) Registered Office: Digital Technium, Singleton Park, Swansea. SA2
	8PP
Date: Mon, 07 Jul 2008 11:21:31 +0100
Message-Id: <1215426091.4011.118.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2008-07-07 at 18:04 +0800, Li Xiaodong wrote:
> The implementation of gfs2_inode_attr_in is removed.
> So remove its declaration.
> 
> Signed-off-by: Li Xiaodong <lixd@cn.fujitsu.com>
> 
> ---
>  fs/gfs2/inode.h |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h index 580da45..d2ddb84 100644
> --- a/fs/gfs2/inode.h
> +++ b/fs/gfs2/inode.h
> @@ -72,7 +72,6 @@ static inline void gfs2_inum_out(const struct gfs2_inode
> *ip,  }
>  
> 
> -void gfs2_inode_attr_in(struct gfs2_inode *ip);  void gfs2_set_iop(struct
> inode *inode);  struct inode *gfs2_inode_lookup(struct super_block *sb,
> unsigned type, 
>  				u64 no_addr, u64 no_formal_ino,
> --
> 1.5.5.1

This patch looks like its been munged by your mailer. Can you send me a
corrected version?

Steve.


