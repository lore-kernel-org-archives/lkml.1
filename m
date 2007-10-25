Return-Path: <linux-kernel-owner+w=401wt.eu-S1760876AbXJYIXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760876AbXJYIXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 04:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbXJYIXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 04:23:00 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:37256 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbXJYIW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 04:22:59 -0400
Message-ID: <472053D9.8020808@bull.net>
Date: Thu, 25 Oct 2007 10:29:13 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make ipc/util.c:sysvipc_find_ipc() static
References: <20071024162334.GS30533@stusta.de>
In-Reply-To: <20071024162334.GS30533@stusta.de>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 25/10/2007 10:29:35,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 25/10/2007 10:29:36,
	Serialize complete at 25/10/2007 10:29:36
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> sysvipc_find_ipc() can become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> daadf1bd4c81e8b88cfc690cecace9adc8b783f0 
> diff --git a/ipc/util.c b/ipc/util.c
> index 1aa0ebf..76c1f34 100644
> --- a/ipc/util.c
> +++ b/ipc/util.c
> @@ -802,8 +802,8 @@ struct ipc_proc_iter {
>  /*
>   * This routine locks the ipc structure found at least at position pos.
>   */
> -struct kern_ipc_perm *sysvipc_find_ipc(struct ipc_ids *ids, loff_t pos,
> -					loff_t *new_pos)
> +static struct kern_ipc_perm *sysvipc_find_ipc(struct ipc_ids *ids, loff_t pos,
> +					      loff_t *new_pos)
>  {
>  	struct kern_ipc_perm *ipc;
>  	int total, id;
> 
> 

Acked-by: Nadia Derbey <Nadia.Derbey@bull.net>


