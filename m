Return-Path: <linux-kernel-owner+w=401wt.eu-S1764590AbZDHLdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764590AbZDHLdy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764220AbZDHL0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:26:39 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:63538 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764523AbZDHL0i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:26:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=i2SseU8AW1J0WxqBCXJZRTzqjhP5Uma++MQFz9QqeBDR2Op5TcuN0zm0jgvwa/dKjU
         THoB9PVQj2WLPYxTbGc6AfcBymJ7yPxg2Tjfn7f+hMkIQbo58QK19bPAYPktLFPnpeHR
         dAuzDJJFQ3vFj9Ns1cPzyl/pedRVTi5STC6Vw=
MIME-Version: 1.0
In-Reply-To: <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm>
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm>
Date: Wed, 8 Apr 2009 13:26:35 +0200
Message-ID: <36ca99e90904080426r1dd57eddo598df8bae686cae4@mail.gmail.com>
Subject: Re: [PATCH 06/56] cifs: Remove void casts
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 13:21, Jack Stone <jwjstone@fastmail.fm> wrote:
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>  fs/cifs/transport.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 0ad3e2d..fb3bd00 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -111,7 +111,7 @@ AllocOplockQEntry(struct inode *pinode, __u16 fid, struct cifsTconInfo *tcon)
>                cERROR(1, ("Null parms passed to AllocOplockQEntry"));
>                return NULL;
>        }
> -       temp = (struct oplock_q_entry *) kmem_cache_alloc(cifs_oplock_cachep,
> +       temp = kmem_cache_alloc(cifs_oplock_cachep,
>                                                       GFP_KERNEL);
                                                        ^^^^^^^^^^^^
Again.

Bert
>        if (temp == NULL)
>                return temp;
> --
> 1.5.4.3
