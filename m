Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbYDDG5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbYDDG5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 02:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbYDDG5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 02:57:10 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:10087 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbYDDG5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 02:57:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=nQ3pE8oK7ozN9561fx6SVT16ClqKXnrhMOPFxC6HH/wmQWrWf00qwTR70fhyVig/lBJ/tdRr7cc0D1Rm2mRV4yOJJdgyKkOQZ8zYRKuvuyVhrtUIxrZNueu5wTJprkZS+eXJtRY6PWNTL0NtbXtEPVTSPdWWXiTUfuzSWx4G+SY=
Message-ID: <9c9fda240804032357i36e7eac0q1c639a017b27af42@mail.gmail.com>
Date: Fri, 4 Apr 2008 15:57:08 +0900
From: "Kyungmin Park" <kmpark@infradead.org>
To: joern@logfs.org
Subject: Re: [patch 8/15] fs/logfs/inode.c
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
In-Reply-To: <20080401181332.853833008@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080401181308.512473173@logfs.org>
	 <20080401181332.853833008@logfs.org>
X-Google-Sender-Auth: 5ecf9a6bcf878cf8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  +
>  +const struct super_operations logfs_super_operations = {
>  +       .alloc_inode    = logfs_alloc_inode,
>  +       .delete_inode   = logfs_delete_inode,
>  +       .destroy_inode  = logfs_destroy_inode,
>  +       .drop_inode     = logfs_drop_inode,
>  +       .read_inode     = logfs_read_inode,
>  +       .write_inode    = logfs_write_inode,
>  +       .statfs         = logfs_statfs,
>  +       .sync_fs        = logfs_sync_fs,
>  +};

Same reason, 'read_inode' is removed.

After some works, it can compile but there's undefined symbols.
WARNING: "swapper_space" [fs/logfs/logfs.ko] undefined!
WARNING: "add_to_page_cache_lru" [fs/logfs/logfs.ko] undefined!
WARNING: "inode_lock" [fs/logfs/logfs.ko] undefined!

Which kernel version do you use?

Thank you,
Kyungmin Park
