Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbZBZVNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbZBZVNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 16:13:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbZBZVNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 16:13:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753244AbZBZVNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 16:13:24 -0500
Date: Thu, 26 Feb 2009 13:13:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, htejun@gmail.com,
       linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org
Subject: Re: [PATCH] sysfs: Don't block indefinitely for unmapped files.
Message-Id: <20090226131308.41ffbd31.akpm@linux-foundation.org>
In-Reply-To: <m18wnvq6cr.fsf@fess.ebiederm.org>
References: <m18wnvq6cr.fsf@fess.ebiederm.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009 00:16:20 -0800
ebiederm@xmission.com (Eric W. Biederman) wrote:

> +/*
> + * There's one bin_buffer for each open file.
> + *
> + * filp->private_data points to bin_buffer and
> + * sysfs_dirent->s_bin_attr.buffers points to a the bin_buffer s

what is this trying to say?

> + * sysfs_dirent->s_bin_attr.buffers is protected by sysfs_bin_lock
> + */
