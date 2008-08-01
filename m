Return-Path: <linux-kernel-owner+w=401wt.eu-S1759870AbYHAUrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759870AbYHAUrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 16:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbYHAUrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 16:47:16 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:64556 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbYHAUrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 16:47:16 -0400
Date: Fri, 1 Aug 2008 13:46:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: mgross@linux.intel.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, richard@hughsie.com
Subject: Re: spell check patch to pm_qos_params.c
Message-Id: <20080801134617.e82c802c.randy.dunlap@oracle.com>
In-Reply-To: <20080801175245.GC23227@linux.intel.com>
References: <20080801175245.GC23227@linux.intel.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
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

On Fri, 1 Aug 2008 10:52:45 -0700 mark gross wrote:

> This is a documentation clean up patch form Richard Hughes.

from

> 
> With a minor tweak to clarify units for kbs.
> 
> Please apply.
> 
> thanks,
> 
> --mgross
> 
> 
> Signed-off-by: mark gross <mgross@linux.intel.com>
> 
>  Documentation/power/pm_qos_interface.txt |    7 ++++++-
>  include/linux/pm_qos_params.h            |    2 +-
>  kernel/pm_qos_params.c                   |   16 ++++++++--------
>  3 files changed, 15 insertions(+), 10 deletions(-)
> 
> 
> Index: linux-2.6/Documentation/power/pm_qos_interface.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/power/pm_qos_interface.txt	2008-08-01 09:28:42.000000000 -0700
> +++ linux-2.6/Documentation/power/pm_qos_interface.txt	2008-08-01 10:46:04.000000000 -0700

> @@ -7,6 +7,11 @@
>  Currently we have {cpu_dma_latency, network_latency, network_throughput} as the
>  initial set of pm_qos parameters.
>  
> +Each parameters have defined units:

   Each parameter has defined units:

> + * latency: usec
> + * timeout: usec
> + * throughput: kbs (kilo bit / sec)
> +
>  The infrastructure exposes multiple misc device nodes one per implemented
>  parameter.  The set of parameters implement is defined by pm_qos_power_init()
>  and pm_qos_params.h.  This is done because having the available parameters


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
