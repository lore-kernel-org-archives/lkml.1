Return-Path: <linux-kernel-owner+w=401wt.eu-S1759432AbXGURN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432AbXGURN6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 13:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbXGURNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 13:13:50 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:51006 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbXGURNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 13:13:49 -0400
Message-ID: <46A23EC7.9090308@linux.vnet.ibm.com>
Date: Sat, 21 Jul 2007 22:43:43 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Shailabh Nagar <nagar@watson.ibm.com>, Jay Lan <jlan@engr.sgi.com>
Subject: Re: [PATCH][01/37] Clean up duplicate includes in Documentation/
References: <200707211701.37966.jesper.juhl@gmail.com>
In-Reply-To: <200707211701.37966.jesper.juhl@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> Hi,
> 
> This patch cleans up duplicate includes in
> 	Documentation/
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
> 
> diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
> index 24c5aad..0ccfeae 100644
> --- a/Documentation/accounting/getdelays.c
> +++ b/Documentation/accounting/getdelays.c
> @@ -21,7 +21,6 @@
>  #include <sys/types.h>
>  #include <sys/stat.h>
>  #include <sys/socket.h>
> -#include <sys/types.h>
>  #include <signal.h>
> 
>  #include <linux/genetlink.h>

Looks good!

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
