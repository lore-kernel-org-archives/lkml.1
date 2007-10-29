Return-Path: <linux-kernel-owner+w=401wt.eu-S1752481AbXJ2ECR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbXJ2ECR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 00:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbXJ2ECB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 00:02:01 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:49207 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbXJ2ECA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 00:02:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qUVxLiaG8DHWoQr4a5Uni5R9G+NYYD5cnNnM9XagTWAF7nYNtKl9BdKwhWC/qXWhImmtqkg5QC7aIQBEbw8RvZX4IG/hZeDS7kk7/Cl6MuTG7HzYVS+2hM7+b9XgNV6CrExMTV8vQA8vYTznZeIaiAxk/p0xyJW98aHIpjybYj0=
Message-ID: <524f69650710282101h630495damf0b2202d00fd0e46@mail.gmail.com>
Date: Sun, 28 Oct 2007 23:01:59 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Subject: Re: [PATCH] [CIFS] Silence two "defined but unused" warning
Cc: LKML <linux-kernel@vger.kernel.org>, linux-cifs-client@lists.samba.org
In-Reply-To: <20071029135558.f80876d8.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071029135558.f80876d8.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This should already be in the cifs-2.6.git tree and next -mm (I am
waiting on the finish up of some CIFS ACL mapping code before
requesting another cifs merge with mainline)

http://git.kernel.org/?p=linux/kernel/git/sfrench/cifs-2.6.git;a=commitdiff;h=c94897790e7c67dcfe3a0b6f035996398c268313

On 10/28/07, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  fs/cifs/cifssmb.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index f0d9a48..aa9dc9e 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -2486,6 +2486,7 @@ querySymLinkRetry:
>         return rc;
>  }
>
> +#ifdef CONFIG_CIFS_EXPERIMENTAL
>  /* Initialize NT TRANSACT SMB into small smb request buffer.
>     This assumes that all NT TRANSACTS that we init here have
>     total parm and data under about 400 bytes (to fit in small cifs
> @@ -2569,6 +2570,7 @@ validate_ntransact(char *buf, char **ppparm, char **ppdata,
>         }
>         return 0;
>  }
> +#endif /* CONFIG_CIFS_EXPERIMENTAL */
>
>  int
>  CIFSSMBQueryReparseLinkInfo(const int xid, struct cifsTconInfo *tcon,
> --
> 1.5.3.4
>
>


-- 
Thanks,

Steve
