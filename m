Return-Path: <linux-kernel-owner+w=401wt.eu-S1759437AbXEaIyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437AbXEaIyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 04:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755089AbXEaIyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 04:54:40 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:58863 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193AbXEaIyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 04:54:40 -0400
Message-ID: <465E8D4C.9040506@s5r6.in-berlin.de>
Date: Thu, 31 May 2007 10:54:36 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: clameter@sgi.com
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org
Subject: Re: [RFC 1/4] CONFIG_STABLE: Define it
References: <20070531002047.702473071@sgi.com> <20070531003012.302019683@sgi.com>
In-Reply-To: <20070531003012.302019683@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> --- slub.orig/init/Kconfig	2007-05-30 16:35:05.000000000 -0700
> +++ slub/init/Kconfig	2007-05-30 16:35:45.000000000 -0700
> @@ -65,6 +65,13 @@ endmenu
>  
>  menu "General setup"
>  
> +config STABLE
> +	bool "Stable kernel"
> +	help
> +	  If the kernel is configured to be a stable kernel then various
> +	  checks that are only of interest to kernel development will be
> +	  omitted.
> +
>  config LOCALVERSION
>  	string "Local version - append to kernel release"
>  	help

a) Why in Kconfig, why not in Makefile?

b) Of course nobody wants STABLE=n. :-)  How about:

config RELEASE
	bool "Build for release"
	help
	  If the kernel is declared as a release build here, then
	  various checks that are only of interest to kernel development
	  will be omitted.

c) A drawback of this general option is, it's hard to tell what will be
omitted in particular.
-- 
Stefan Richter
-=====-=-=== -=-= =====
http://arcgraph.de/sr/
