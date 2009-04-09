Return-Path: <linux-kernel-owner+w=401wt.eu-S1763128AbZDIJpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763128AbZDIJpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 05:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757824AbZDIJot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 05:44:49 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57127 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754913AbZDIJos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 05:44:48 -0400
X-Sasl-enc: RJdrLf1WcpppnrPq39WhlWHh7MuMeNX5WCR/W56VTHpf 1239270287
Message-ID: <49DDC38D.1080908@fastmail.fm>
Date: Thu, 09 Apr 2009 10:44:45 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jeff@garzik.org, kernel-janitors@vger.kernel.org, sfrench@samba.org
Subject: Re: [PATCH 06/56] cifs: Remove void casts
References: <> <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm>
In-Reply-To: <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added maintainer CC]
Jack Stone wrote:
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>  fs/cifs/transport.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 0ad3e2d..fb3bd00 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -111,7 +111,7 @@ AllocOplockQEntry(struct inode *pinode, __u16 fid, struct cifsTconInfo *tcon)
>  		cERROR(1, ("Null parms passed to AllocOplockQEntry"));
>  		return NULL;
>  	}
> -	temp = (struct oplock_q_entry *) kmem_cache_alloc(cifs_oplock_cachep,
> +	temp = kmem_cache_alloc(cifs_oplock_cachep,
>  						       GFP_KERNEL);
>  	if (temp == NULL)
>  		return temp;
>   

