Return-Path: <linux-kernel-owner+w=401wt.eu-S933113AbZDIKNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113AbZDIKNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761146AbZDIKNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 06:13:41 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:32946 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758975AbZDIKNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 06:13:40 -0400
X-Sasl-enc: QcqBJsw7zqbs/Q9mzheGQsq4kvNGAsAFwjwe7tzf3c6K 1239272019
Message-ID: <49DDCA4F.1040605@fastmail.fm>
Date: Thu, 09 Apr 2009 11:13:35 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jeff@garzik.org, kernel-janitors@vger.kernel.org, per.liden@ericsson.com,
       jon.maloy@ericsson.com, allan.stephens@windriver.com
Subject: Re: [PATCH 33/56] tipc: Remove void casts
References: <> <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-22-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-23-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-24-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-25-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-26-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-27-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-28-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-29-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-30-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-31-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-32-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-33-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-34-git-send-email-jwjstone@fastmail.fm>
In-Reply-To: <1239189748-11703-34-git-send-email-jwjstone@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added maintainer CCs]
Jack Stone wrote:
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>  net/tipc/port.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/tipc/port.c b/net/tipc/port.c
> index e70d27e..0804ae2 100644
> --- a/net/tipc/port.c
> +++ b/net/tipc/port.c
> @@ -1528,7 +1528,7 @@ int tipc_forward_buf2name(u32 ref,
>  	u32 destport = 0;
>  	int res;
>  
> -	p_ptr = (struct port *)tipc_ref_deref(ref);
> +	p_ptr = tipc_ref_deref(ref);
>  	if (!p_ptr || p_ptr->publ.connected)
>  		return -EINVAL;
>  
> @@ -1656,7 +1656,7 @@ int tipc_forward_buf2port(u32 ref,
>  	struct tipc_msg *msg;
>  	int res;
>  
> -	p_ptr = (struct port *)tipc_ref_deref(ref);
> +	p_ptr = tipc_ref_deref(ref);
>  	if (!p_ptr || p_ptr->publ.connected)
>  		return -EINVAL;
>  
>   

