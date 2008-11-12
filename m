Return-Path: <linux-kernel-owner+w=401wt.eu-S1753943AbYKLRV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbYKLRV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 12:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbYKLRVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 12:21:49 -0500
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:50081 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751468AbYKLRVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 12:21:48 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAD6cGklMQWxa/2dsb2JhbACBds4wg1c
Date: Wed, 12 Nov 2008 12:21:47 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] markers: Add missing stdargs.h include, needed due to
	va_list usage
Message-ID: <20081112172147.GD24126@Krystal>
References: <20081112125212.GA13263@ghostprotocols.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081112125212.GA13263@ghostprotocols.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:21:02 up 160 days, 22:01,  7 users,  load average: 5.58, 3.85,
	2.30
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnaldo Carvalho de Melo (acme@redhat.com) wrote:
> diff --git a/include/linux/marker.h b/include/linux/marker.h
> index 889196c..6213b5e 100644
> --- a/include/linux/marker.h
> +++ b/include/linux/marker.h
> @@ -12,6 +12,7 @@
>   * See the file COPYING for more details.
>   */
>  
> +#include <stdarg.h>

Hrm given it's already included in kernel.h for printk, I am not sure
it's required here ? Although it cannot hurt to add it explicitly.

Mathieu

>  #include <linux/types.h>
>  
>  struct module;

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
