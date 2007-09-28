Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbXI1HkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbXI1HkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 03:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbXI1HkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 03:40:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40732 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752992AbXI1HkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 03:40:03 -0400
Date: Fri, 28 Sep 2007 00:39:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pierre Peiffer <pierre.peiffer@bull.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [resend][PATCH] Remove duplicated declarations in procfs
Message-Id: <20070928003927.6d08c050.akpm@linux-foundation.org>
In-Reply-To: <46FCACFC.3010103@bull.net>
References: <46FCACFC.3010103@bull.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 09:27:56 +0200 Pierre Peiffer <pierre.peiffer@bull.net> wrote:

> From: Pierre Peiffer <pierre.peiffer@bull.net>
> 
> This is a trivial patch that removes some duplicated declarations of
> extern variables.
> 
> Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>
> ---
> 
>  fs/proc/internal.h |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/proc/internal.h b/fs/proc/internal.h
> index b215c35..d812816 100644
> --- a/fs/proc/internal.h
> +++ b/fs/proc/internal.h
> @@ -50,10 +50,6 @@ extern const struct file_operations proc_maps_operations;
>  extern const struct file_operations proc_numa_maps_operations;
>  extern const struct file_operations proc_smaps_operations;
>  
> -extern const struct file_operations proc_maps_operations;
> -extern const struct file_operations proc_numa_maps_operations;
> -extern const struct file_operations proc_smaps_operations;
> -
>  
>  void free_proc_entry(struct proc_dir_entry *de);

yup, thanks, the maps2 patches in -mm already accidentally fixed this so I haven't
bothered merging it as a standalone thing.

