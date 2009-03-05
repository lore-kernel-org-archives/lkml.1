Return-Path: <linux-kernel-owner+w=401wt.eu-S1756500AbZCESRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbZCESRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 13:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbZCESQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 13:16:58 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:51836 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbZCESQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 13:16:57 -0500
Subject: Re: [RFC][PATCH 00/11] track files for checkpointability
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20090305181325.GA10666@us.ibm.com>
References: <20090305163857.0C18F3FD@kernel>
	 <20090305181325.GA10666@us.ibm.com>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 10:16:43 -0800
Message-Id: <1236277003.22399.89.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-05 at 12:13 -0600, Serge E. Hallyn wrote:
> 
> ---
>  fs/proc/base.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index bde92c3..12543b6 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1657,7 +1657,7 @@ static void proc_fd_write_info(struct file *file, char *info)
> 
>         if (file->f_op->checkpoint)
>                 checkpointable = 1;
> -       p += scnprintf(info+p, max-p, "checkpointable:\t%d", checkpointable);
> +       p += scnprintf(info+p, max-p, "checkpointable:\t%d\n", checkpointable);
>         if (!checkpointable)
>                 p += cr_explain_file(file, info+p, max-p);
>  }

I'll apply that, thanks Serge.

-- Dave

