Return-Path: <linux-kernel-owner+w=401wt.eu-S1755647AbXJAQlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbXJAQlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 12:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbXJAQlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 12:41:07 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:42865 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbXJAQlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 12:41:06 -0400
Date: Mon, 1 Oct 2007 09:37:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>, Cedric Le Goater <clg@fr.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH 1/5] The config option itself
Message-Id: <20071001093715.c4f10fe0.randy.dunlap@oracle.com>
In-Reply-To: <47011347.70906@openvz.org>
References: <470112C7.8000803@openvz.org>
	<47011347.70906@openvz.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Oct 2007 19:33:27 +0400 Pavel Emelyanov wrote:

> diff --git a/init/Kconfig b/init/Kconfig
> index 6bb603a..67b1e41 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -390,6 +381,23 @@ config RELAY
>  
>  	  If unsure, say N.
>  
> +config NAMESPACES
> +	bool "Namespaces support" if EMBEDDED
> +	default !EMBEDDED
> +	help
> +	  Provides the way to make tasks work with different objects using
> +	  the same id. For example same IPC id may refer to different objects
> +	  or same user id or pid may refer to different tasks when used in
> +	  different namespaces.
> +
> +config NAMESPACES_EXPERIMENTAL
> +	bool "Add experimantal namespaces support"

                  experimental

> +	depends on NAMESPACES && EXPERIMENTAL
> +	default n
> +	help
> +	  Also include the support for the namespaces that are not fnished

                                                                   finished

> +	  or well developed yet
> +
>  config BLK_DEV_INITRD
>  	bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"
>  	depends on BROKEN || !FRV


---
~Randy
