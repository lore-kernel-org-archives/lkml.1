Return-Path: <linux-kernel-owner+w=401wt.eu-S1765276AbZDIJvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765276AbZDIJvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 05:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760541AbZDIJvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 05:51:12 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:60538 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762320AbZDIJvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 05:51:10 -0400
X-Sasl-enc: FiHe3wO0WbEvveU76BVMjjUI/6zzZ60Yov51Mak7r19p 1239270669
Message-ID: <49DDC50A.4070707@fastmail.fm>
Date: Thu, 09 Apr 2009 10:51:06 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: Bert Wesarg <bert.wesarg@googlemail.com>
CC: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org, sfrench@samba.org
Subject: Re: [PATCH 06/56] cifs: Remove void casts
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm> <36ca99e90904080426r1dd57eddo598df8bae686cae4@mail.gmail.com> <49DCABD6.4080209@fastmail.fm>
In-Reply-To: <49DCABD6.4080209@fastmail.fm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry I CCd the wrong patch. Here is the corrected version.

Thanks,

Jack

Jack Stone wrote:
> Fixed patch
>
> Thanks
>
> Jack
>
> --
>
> cifs: Remove void casts
>
> From: Jack Stone <jwjstone@fastmail.fm>
>
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>
>  fs/cifs/transport.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 0ad3e2d..86191b0 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -111,8 +111,7 @@ AllocOplockQEntry(struct inode *pinode, __u16 fid,
> struct cifsTconInfo *tcon)
>          cERROR(1, ("Null parms passed to AllocOplockQEntry"));
>          return NULL;
>      }
> -    temp = (struct oplock_q_entry *) kmem_cache_alloc(cifs_oplock_cachep,
> -                               GFP_KERNEL);
> +    temp = kmem_cache_alloc(cifs_oplock_cachep, GFP_KERNEL);
>      if (temp == NULL)
>          return temp;
>      else {
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

