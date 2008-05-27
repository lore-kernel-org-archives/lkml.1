Return-Path: <linux-kernel-owner+w=401wt.eu-S1760286AbYE0VnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286AbYE0VnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 17:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759876AbYE0Vmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 17:42:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758847AbYE0Vml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 17:42:41 -0400
Date: Tue, 27 May 2008 14:40:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Baron <jbaron@redhat.com>
Cc: joe@perches.com, greg@kroah.com, nick@nick-andrew.net,
       randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] debug printk infrastructure -dynamic printk docs
Message-Id: <20080527144028.83f87adc.akpm@linux-foundation.org>
In-Reply-To: <20080522211723.GE28070@redhat.com>
References: <20080522211723.GE28070@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008 17:17:23 -0400
Jason Baron <jbaron@redhat.com> wrote:

> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> ---
>  Documentation/kernel-parameters.txt |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index bf6303e..d9a1245 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1580,6 +1580,11 @@ and is between 256 and 4096 characters. It is defined in the file
>  			autoconfiguration.
>  			Ranges are in pairs (memory base and size).
>  
> +	dynamic_printk
> +			Enables pr_debug()/dev_dbg() calls if 
> +			CONFIG_PRINK_DYNAMIC has been enabled. These can also 
> +			be switched on/off via <debugfs>/dynamic_printk/modules
> +

There is no CONFIG_PRINK_DYNAMIC?  I guess you meant
CONFIG_DYNAMIC_PRINTK_DEBUG.

>  	print-fatal-signals=
>  			[KNL] debug: print fatal signals
>  			print-fatal-signals=1: print segfault info to
> -- 
> 1.5.4.5
> 
