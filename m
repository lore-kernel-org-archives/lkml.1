Return-Path: <linux-kernel-owner+w=401wt.eu-S1759537AbZJPNZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537AbZJPNZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 09:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759332AbZJPNZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 09:25:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:37171 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759320AbZJPNZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 09:25:50 -0400
Date: Fri, 16 Oct 2009 15:25:12 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       "David S. Miller" <davem@davemloft.net>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Wang Chen <wangchen@cn.fujitsu.com>, linux-bluetooth@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] trivial: fix typo s/refference/reference/ in
 comment
In-Reply-To: <1255637783-6109-1-git-send-email-cascardo@holoscopio.com>
Message-ID: <alpine.LSU.2.00.0910161524480.8582@wotan.suse.de>
References: <1255637783-6109-1-git-send-email-cascardo@holoscopio.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009, Thadeu Lima de Souza Cascardo wrote:

> diff --git a/net/bluetooth/bnep/core.c b/net/bluetooth/bnep/core.c
> index cafe9f5..1bd9398 100644
> --- a/net/bluetooth/bnep/core.c
> +++ b/net/bluetooth/bnep/core.c
> @@ -78,7 +78,7 @@ static struct bnep_session *__bnep_get_session(u8 *dst)
>  static void __bnep_link_session(struct bnep_session *s)
>  {
>  	/* It's safe to call __module_get() here because sessions are added
> -	   by the socket layer which has to hold the refference to this module.
> +	   by the socket layer which has to hold the reference to this module.
>  	 */
>  	__module_get(THIS_MODULE);
>  	list_add(&s->list, &bnep_session_list);

Merged together with patches 2-8 from your series and applied to trivial
queue.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
