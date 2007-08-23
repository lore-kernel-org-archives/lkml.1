Return-Path: <linux-kernel-owner+w=401wt.eu-S1760893AbXHWQqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760893AbXHWQqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 12:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756636AbXHWQqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 12:46:23 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48371 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756571AbXHWQqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 12:46:22 -0400
Date: Thu, 23 Aug 2007 11:46:21 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: akpm@osdl.org, devel@openvz.org, linux-kernel@vger.kernel.org,
       serue@us.ibm.com, Cedric Le Goater <clg@fr.ibm.com>
Subject: Re: [PATCH] userns: don't leak root user
Message-ID: <20070823164621.GA15690@sergelap.austin.ibm.com>
References: <20070823092259.GB31289@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823092259.GB31289@localhost.sw.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@sw.ru):
> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>

Thanks, Alexey.

Signed-off-by: Serge Hallyn <serue@us.ibm.com>

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
> 
