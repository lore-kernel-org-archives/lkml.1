Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbXITFZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbXITFZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 01:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbXITFZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 01:25:24 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33899 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750899AbXITFZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 01:25:23 -0400
Date: Wed, 19 Sep 2007 22:25:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       ecryptfs-devel@lists.sourceforge.net
Subject: Re: [PATCH 3/11] eCryptfs: read_write.c routines
Message-Id: <20070919222505.28a238b0.akpm@linux-foundation.org>
In-Reply-To: <20070917214632.GK13679@halcrow.austin.ibm.com>
References: <20070917214436.GH13679@halcrow.austin.ibm.com>
	<20070917214632.GK13679@halcrow.austin.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2007 16:46:32 -0500 Michael Halcrow <mhalcrow@us.ibm.com> wrote:

> +/**
> + * ecryptfs_write_lower
> + * @ecryptfs_inode: The eCryptfs inode
> + * @data: Data to write
> + * @offset: Byte offset in the lower file to which to write the data
> + * @size: Number of bytes from @data to write at @offset in the lower
> + *        file
> + *
> + * Write data to the lower file.
> + *
> + * Returns zero on success; non-zero on error
> + */

That might come out looking odd in the kernel doc?  Normally the documentation
would start out with

+/**
+ * ecryptfs_write_lower - write data to the lower file

