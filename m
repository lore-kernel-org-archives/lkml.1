Return-Path: <linux-kernel-owner+w=401wt.eu-S1763297AbXHWOsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763297AbXHWOsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 10:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760318AbXHWOry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 10:47:54 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:53626 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758648AbXHWOry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 10:47:54 -0400
Message-ID: <46CD9E13.6020006@fr.ibm.com>
Date: Thu, 23 Aug 2007 16:47:47 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@sw.ru>
CC: akpm@osdl.org, devel@openvz.org, linux-kernel@vger.kernel.org,
       serue@us.ibm.com
Subject: Re: [PATCH] userns: don't leak root user
References: <20070823092259.GB31289@localhost.sw.ru>
In-Reply-To: <20070823092259.GB31289@localhost.sw.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
> ---
> 
>  kernel/user_namespace.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -81,6 +81,7 @@ void free_user_ns(struct kref *kref)
>  	struct user_namespace *ns;
> 
>  	ns = container_of(kref, struct user_namespace, kref);
> +	free_uid(ns->root_user);
>  	kfree(ns);
>  }

Indeed ... 

Thanks !

C.
