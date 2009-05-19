Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbZESJma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbZESJma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 05:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbZESJmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 05:42:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51342 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbZESJmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 05:42:22 -0400
Date: Tue, 19 May 2009 11:42:20 +0200
From: Jan Blunck <jblunck@suse.de>
To: Andreas Dilger <adilger@sun.com>
Cc: viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 30/32] union mount: ext2 fallthru support
Message-ID: <20090519094220.GI16526@bolzano.suse.de>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de> <1242662968-11684-31-git-send-email-jblunck@suse.de> <20090518163221.GE3144@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090518163221.GE3144@webber.adilger.int>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 18, Andreas Dilger wrote:

> For enums like this that require specific constant on-disk values
> I prefer being safe:
> 
> enum {
> 	EXT2_FT_UNKNOWN  = 0,
> 	EXT2_FT_REG_FILE = 1,
> 	EXT2_FT_DIR	 = 2,
> 	EXT2_FT_CHRDEV   = 3,
> 	EXT2_FT_BLKDEV   = 4,
> 	EXT2_FT_FIFO     = 5,
> 	EXT2_FT_SOCK     = 6,
> 	EXT2_FT_SYMLINK  = 7,
> 	EXT2_FT_WHT      = 8,
> 	EXT2_FT_FALLTHRU = 9,
>  	EXT2_FT_MAX
> 
> 
> It probably also makes sense to include a patch for ext3/ext4 to ensure
> these values are not used by some unrelated feature.

In ext3 these are preprocessor defines. IIRC defines and enums are identical
for C (both an int) so I leave this untouched and just add the new filetypes,
right?

Thanks,
Jan
