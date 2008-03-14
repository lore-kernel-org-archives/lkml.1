Return-Path: <linux-kernel-owner+w=401wt.eu-S1760037AbYCNUHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760037AbYCNUHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 16:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758882AbYCNUGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 16:06:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757069AbYCNUGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 16:06:52 -0400
Date: Fri, 14 Mar 2008 13:05:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, hch@lst.de, dhowells@redhat.com,
       marc.c.dionne@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] struct export_operations: adjust comments to match
 current members
Message-Id: <20080314130527.35c595eb.akpm@linux-foundation.org>
In-Reply-To: <22062.1205500289@redhat.com>
References: <22062.1205500289@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008 13:11:29 +0000
David Howells <dhowells@redhat.com> wrote:

> 
> From: "Marc Dionne" <marc.c.dionne@gmail.com>
> 
> The comments in the definition of struct export_operations don't match the
> current members.
> 
> Add a comment for the 2 new functions and remove 2 comments for unused ones.
> 
> Signed-off-by: Marc Dionne <marc.c.dionne@gmail.com>
> Acked-by: David Howells <dhowells@redhat.com>

I changed this to Signed-off-by:.  You were in the delivery path.

> ---
>  include/linux/exportfs.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
> index 51d2141..adcbb05 100644
> --- a/include/linux/exportfs.h
> +++ b/include/linux/exportfs.h
> @@ -49,11 +49,11 @@ struct fid {
> 
>  /**
>   * struct export_operations - for nfsd to communicate with file systems
> - * @decode_fh:      decode a file handle fragment and return a &struct dentry
>   * @encode_fh:      encode a file handle fragment from a dentry
> + * @fh_to_dentry:   find the implied object and get a dentry for it
> + * @fh_to_parent:   find the implied object's parent and get a dentry for it
>   * @get_name:       find the name for a given inode in a given directory
>   * @get_parent:     find the parent of a given directory
> - * @get_dentry:     find a dentry for the inode given a file handle
> sub-fragment

Someone is wordwrapping.

>   *
>   * See Documentation/filesystems/Exporting for details on how to use
>   * this interface correctly.
