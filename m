Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbYJBGL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbYJBGL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 02:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbYJBGLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 02:11:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45671 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752386AbYJBGLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 02:11:46 -0400
Date: Wed, 1 Oct 2008 23:11:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: John Jolly <jjolly@novell.com>
Cc: axboe@kernel.dk, JBlunck@novell.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] block: installing include/linux/blktrace_api.h
Message-Id: <20081001231138.266452cc.akpm@linux-foundation.org>
In-Reply-To: <48DA5317.9030705@novell.com>
References: <48DA5317.9030705@novell.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 24 Sep 2008 08:47:51 -0600 John Jolly <jjolly@novell.com> wrote:
> From: John Jolly <jjolly@novell.com>
> 
> Added line to install include/linux/blktrace_api.h during 'make headers_install'
> 
> Signed-off-by: John Jolly <jjolly@novell.com>
> CC: Jan Blunck <JBlunck@novell.com>
> ---
>  include/linux/Kbuild |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/Kbuild b/include/linux/Kbuild
> index b68ec09..f1e5fa1 100644
> --- a/include/linux/Kbuild
> +++ b/include/linux/Kbuild
> @@ -41,6 +41,7 @@ header-y += baycom.h
>  header-y += bfs_fs.h
>  header-y += blkpg.h
>  header-y += bpqether.h
> +header-y += blktrace_api.h
>  header-y += can.h
>  header-y += cdk.h
>  header-y += chio.h

The two basic and almost always necessary parts of a patch changelog are

a) what was changed and

b) why the change was made

Your changelog had no b), hence nobody is likely to apply the patch.
