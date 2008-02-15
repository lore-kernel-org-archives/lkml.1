Return-Path: <linux-kernel-owner+w=401wt.eu-S1764141AbYBOWhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764141AbYBOWhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756190AbYBOWh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:37:26 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:44115 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755362AbYBOWhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:37:24 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAFOjtUdMQWRV/2dsb2JhbACBWax+
Date: Fri, 15 Feb 2008 17:37:21 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Chris Snook <csnook@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MARKERS depends on MODULES
Message-ID: <20080215223721.GA18891@Krystal>
References: <20080215222848.GA2440@shell.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080215222848.GA2440@shell.boston.redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:36:47 up 4 days, 18:37,  4 users,  load average: 0.32, 0.28,
	0.30
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chris Snook (csnook@redhat.com) wrote:
> From: Chris Snook <csnook@redhat.com>
> 
> Make MARKERS depend on MODULES to prevent build failures with certain configs.
> 
> Signed-off-by: Chris Snook <csnook@redhat.com>
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index dcef8b5..933df15 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -729,6 +729,7 @@ config PROFILING
>  
>  config MARKERS
>  	bool "Activate markers"
> +	depends on MODULES
>  	help
>  	  Place an empty function call at each marker site. Can be
>  	  dynamically changed for a probe function.

It should not be needed. Please try Adrian's fix there :
http://lkml.org/lkml/2008/2/13/714

It should fix your problem.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
