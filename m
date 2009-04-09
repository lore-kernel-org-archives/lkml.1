Return-Path: <linux-kernel-owner+w=401wt.eu-S932883AbZDIKMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883AbZDIKMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765482AbZDIKLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 06:11:33 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45642 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765089AbZDIKLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 06:11:31 -0400
X-Sasl-enc: 7VSttWOsEAXxSM6Ws6jABSXjEtJ7e4O/8DxHwuw3vZv0 1239271883
Message-ID: <49DDC9C7.7050407@fastmail.fm>
Date: Thu, 09 Apr 2009 11:11:19 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       vladislav.yasevich@hp.com
Subject: Re: [PATCH 31/56] sctp: Remove void casts
References: <> <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-22-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-23-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-24-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-25-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-26-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-27-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-28-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-29-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-30-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-31-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-32-git-send-email-jwjstone@fastmail.fm>
In-Reply-To: <1239189748-11703-32-git-send-email-jwjstone@fastmail.fm>
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
>  net/sctp/socket.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 5fb3a8c..3ed4b4d 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -227,7 +227,7 @@ struct sctp_association *sctp_id2assoc(struct sock *sk, sctp_assoc_t id)
>  		return NULL;
>  
>  	spin_lock_bh(&sctp_assocs_id_lock);
> -	asoc = (struct sctp_association *)idr_find(&sctp_assocs_id, (int)id);
> +	asoc = idr_find(&sctp_assocs_id, (int)id);
>  	spin_unlock_bh(&sctp_assocs_id_lock);
>  
>  	if (!asoc || (asoc->base.sk != sk) || asoc->base.dead)
>   

