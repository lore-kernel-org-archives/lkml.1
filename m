Return-Path: <linux-kernel-owner+w=401wt.eu-S1763493AbYBURbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763493AbYBURbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 12:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750900AbYBURbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 12:31:16 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:26396 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbYBURbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 12:31:15 -0500
Date: Thu, 21 Feb 2008 09:29:11 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Chris Snook <csnook@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make LKDTM depend on BLOCK
Message-Id: <20080221092911.93ca154e.randy.dunlap@oracle.com>
In-Reply-To: <20080215081736.GA22933@shell.boston.redhat.com>
References: <20080215081736.GA22933@shell.boston.redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008 03:17:36 -0500 Chris Snook wrote:

> From: Chris Snook <csnook@redhat.com>
> 
> Make LKDTM depend on BLOCK to prevent build failures with certain configs.
> 
> Signed-off-by: Chris Snook <csnook@redhat.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index a370fe8..24b327c 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -524,6 +524,7 @@ config LKDTM
>  	tristate "Linux Kernel Dump Test Tool Module"
>  	depends on DEBUG_KERNEL
>  	depends on KPROBES
> +	depends on BLOCK
>  	default n
>  	help
>  	This module enables testing of the different dumping mechanisms by

---
~Randy
