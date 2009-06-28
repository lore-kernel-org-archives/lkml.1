Return-Path: <linux-kernel-owner+w=401wt.eu-S1760528AbZF1Qp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760528AbZF1Qp4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbZF1Qps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:45:48 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:38432 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbZF1Qpr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:45:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ouW7Ek5/lFxgEVovQZh5yHBBKtApyLURF0lGVsi/9pW/XDNi8cpn8Yux8dJKCGFiGC
         WJELpNwGcO/BgfSmvcpYC/BEcjE31sec5w8m3X31OKYmqZXj1MdDCnqE2AoyN4WjN6ZI
         xQL1PBCTSMK83Zifcxrd/zbYITd75l0W3ZJRY=
MIME-Version: 1.0
In-Reply-To: <33feb04c647d39629feb6252488214b05e297f44.1246173683.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
	 <33feb04c647d39629feb6252488214b05e297f44.1246173683.git.joe@perches.com>
Date: Sun, 28 Jun 2009 11:45:50 -0500
Message-ID: <524f69650906280945w75efb203mbd3a5770acf97188@mail.gmail.com>
Subject: Re: [PATCH 56/62] fs/cifs/cifs_dfs_ref.c: Remove unnecessary 
	semicolons
From: Steve French <smfrench@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-cifs-client@lists.samba.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fix is fine of course.

Do you prefer that I merge this via the cifs-2.6 tree or as part of
your large patch series?

On Sun, Jun 28, 2009 at 11:27 AM, Joe Perches<joe@perches.com> wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/cifs/cifs_dfs_ref.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
> index 3bb11be..3f2c2a3 100644
> --- a/fs/cifs/cifs_dfs_ref.c
> +++ b/fs/cifs/cifs_dfs_ref.c
> @@ -136,7 +136,7 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
>        rc = dns_resolve_server_name_to_ip(*devname, &srvIP);
>        if (rc != 0) {
>                cERROR(1, ("%s: Failed to resolve server part of %s to IP: %d",
> -                         __func__, *devname, rc));;
> +                         __func__, *devname, rc));
>                goto compose_mount_options_err;
>        }
>        /* md_len = strlen(...) + 12 for 'sep+prefixpath='
> --
> 1.6.3.1.10.g659a0.dirty
>
>



-- 
Thanks,

Steve
