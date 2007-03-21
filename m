Return-Path: <linux-kernel-owner+w=401wt.eu-S933917AbXCUUju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933917AbXCUUju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 16:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934000AbXCUUju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 16:39:50 -0400
Received: from smtp.osdl.org ([65.172.181.24]:52867 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933917AbXCUUjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 16:39:49 -0400
Date: Wed, 21 Mar 2007 13:39:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: sukadev@us.ibm.com
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       serue@us.ibm.com, haveblue@us.ibm.com,
       Containers <containers@lists.osdl.org>, clg@fr.ibm.com
Subject: Re: [PATCH] Define CLONE_NEWPID flag
Message-Id: <20070321133938.bff535a3.akpm@linux-foundation.org>
In-Reply-To: <20070321194103.GA29820@us.ibm.com>
References: <20070321194103.GA29820@us.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007 12:41:03 -0700
sukadev@us.ibm.com wrote:

> 
> This was discussed on containers and we thought it would be useful
> to reserve this flag.
> ---
> 
> From: Sukadev Bhattiprolu <sukadev@us.ibm.com>
> Subject: [PATCH] Define CLONE_NEWPID flag
> 
> Define CLONE_NEWPID flag that will be used to clone pid namespaces.
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
> ---
>  include/linux/sched.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: lx26-21-rc3-mm2/include/linux/sched.h
> ===================================================================
> --- lx26-21-rc3-mm2.orig/include/linux/sched.h	2007-03-20 20:13:19.000000000 -0700
> +++ lx26-21-rc3-mm2/include/linux/sched.h	2007-03-21 11:10:33.000000000 -0700
> @@ -26,6 +26,7 @@
>  #define CLONE_STOPPED		0x02000000	/* Start in stopped state */
>  #define CLONE_NEWUTS		0x04000000	/* New utsname group? */
>  #define CLONE_NEWIPC		0x08000000	/* New ipcs */
> +#define CLONE_NEWPID		0x10000000      /* New pid namespace */
>  

Do we actually have any need to reserve it at this time?  I'd have thought
that we could defer adding this until we have some code in-kernel which
uses it.

