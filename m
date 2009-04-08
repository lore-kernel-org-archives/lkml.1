Return-Path: <linux-kernel-owner+w=401wt.eu-S933397AbZDHMUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397AbZDHMUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759304AbZDHMTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:19:52 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:52269 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758915AbZDHMTu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:19:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=k0YJndXChxx/jNEJOMQh8bCU/SDZsWl++GzFWphade1TfLyPIpTCA3xzkiKy5Me00c
         3iMDhjGdZS8q6dkAatEDrZOwPz/U9GEomntY7+e89m5kgO+4QTLmCoroPxs2ShcWzmFn
         eHvKvFvsnU6zkONo6bvxd5nwqYrhjPWK+8Wmc=
MIME-Version: 1.0
In-Reply-To: <1239189748-11703-37-git-send-email-jwjstone@fastmail.fm>
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-29-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-30-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-31-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-32-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-33-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-34-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-35-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-36-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-37-git-send-email-jwjstone@fastmail.fm>
Date: Wed, 8 Apr 2009 14:19:47 +0200
Message-ID: <36ca99e90904080519s2996a423yfe7eca91a411c8c1@mail.gmail.com>
Subject: Re: [PATCH 36/56] ocfs2: Remove void casts
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 13:22, Jack Stone <jwjstone@fastmail.fm> wrote:
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>  fs/ocfs2/dlm/dlmmaster.c |   10 ++++------
>  1 files changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index f8b653f..e4c2f5b 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -2455,7 +2453,7 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
>                goto leave;
>        }
>
> -       mle = (struct dlm_master_list_entry *) kmem_cache_alloc(dlm_mle_cache,
> +       mle = kmem_cache_alloc(dlm_mle_cache,
>                                                                GFP_NOFS);
Flag.

>        if (!mle) {
>                mlog_errno(ret);
> @@ -3036,7 +3034,7 @@ int dlm_migrate_request_handler(struct o2net_msg *msg, u32 len, void *data,
>        hash = dlm_lockid_hash(name, namelen);
>
>        /* preallocate.. if this fails, abort */
> -       mle = (struct dlm_master_list_entry *) kmem_cache_alloc(dlm_mle_cache,
> +       mle = kmem_cache_alloc(dlm_mle_cache,
>                                                         GFP_NOFS);
Flag.

>
>        if (!mle) {
> --
Bert
