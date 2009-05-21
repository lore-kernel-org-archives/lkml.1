Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbZEUNx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbZEUNx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 09:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246AbZEUNxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 09:53:49 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:41193 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbZEUNxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 09:53:48 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; CHARSET=US-ASCII
Date: Thu, 21 May 2009 09:53:15 -0400
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] Userland for VFS based Union Mount (V3)
In-reply-to: <20090518204019.GC15754@shell>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Jan Blunck <jblunck@suse.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       bharata@in.ibm.com, dwmw2@infradead.org, mszeredi@suse.cz
Message-id: <20090521135315.GA12502@webber.adilger.int>
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <1242662968-11684-1-git-send-email-jblunck@suse.de>
 <20090518204019.GC15754@shell>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 18, 2009  16:40 -0400, Valerie Aurora wrote:
> @@ -705,8 +707,9 @@ struct ext2_dir_entry_2 {
>  #define EXT2_FT_FIFO		5
>  #define EXT2_FT_SOCK		6
>  #define EXT2_FT_SYMLINK		7
> +#define EXT2_FT_WHT		8
>  
> -#define EXT2_FT_MAX		8
> +#define EXT2_FT_MAX		9

What about the EXT2_FT_FALLTHROUGH used in the union mount patches?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

