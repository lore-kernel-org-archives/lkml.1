Return-Path: <linux-kernel-owner+w=401wt.eu-S1759904AbXIQU6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904AbXIQU6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 16:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756825AbXIQU6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 16:58:30 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:25959 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261AbXIQU63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 16:58:29 -0400
Date: Mon, 17 Sep 2007 13:55:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Andi Kleen <andi@firstfloor.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 2/7] Immediate Values - Kconfig menu in EMBEDDED
Message-Id: <20070917135517.2436c575.randy.dunlap@oracle.com>
In-Reply-To: <20070917184319.915814997@polymtl.ca>
References: <20070917184224.549435917@polymtl.ca>
	<20070917184319.915814997@polymtl.ca>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2007 14:42:26 -0400 Mathieu Desnoyers wrote:

>  init/Kconfig |   21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> Index: linux-2.6-lttng/init/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/init/Kconfig	2007-09-04 11:53:59.000000000 -0400
> +++ linux-2.6-lttng/init/Kconfig	2007-09-04 12:12:03.000000000 -0400
> @@ -407,6 +407,17 @@ config CC_OPTIMIZE_FOR_SIZE
>  config SYSCTL
>  	bool
>  
> +config IMMEDIATE
> +	default y if !DISABLE_IMMEDIATE
> +	depends on X86_32 || PPC || PPC64
> +	bool
> +	help
> +	  Immediate values are used as read mostly variables that are rarely

                                       read-mostly

> +	  updated. They use code patching to modify the values inscribed in the
> +	  instruction stream. It provides a way to save precious cache lines

They .... (then) It ...
so choose one of the other.  I think I prefer "They".

> +	  that would otherwise have to be used by these variables. Can be
> +	  disabled through the EMBEDDED menu.
> +
>  menuconfig EMBEDDED
>  	bool "Configure standard kernel features (for small systems)"
>  	help

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
