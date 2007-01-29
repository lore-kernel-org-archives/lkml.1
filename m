Return-Path: <linux-kernel-owner+w=401wt.eu-S1752519AbXA2Rim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbXA2Rim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 12:38:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbXA2Rim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 12:38:42 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:8840 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbXA2Ril (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 12:38:41 -0500
Message-ID: <45BE30CD.1080904@mvista.com>
Date: Mon, 29 Jan 2007 07:37:17 -1000
From: akuster <akuster@mvista.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-pm@lists.osdl.org, Andrew Morton <akpm@osdl.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] PM: fast power off - core
References: <45BBB097.1090207@mvista.com> <20070128100942.edb5f7e1.randy.dunlap@oracle.com>
In-Reply-To: <20070128100942.edb5f7e1.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Randy Dunlap wrote:
> On Sat, 27 Jan 2007 10:05:43 -1000 akuster wrote:
> 
>> My apologies, I cc'd the wrong list the first time around.
> 
> {argh, attachments}

my bad
> 
> --- linux-2.6_dev.orig/kernel/power/Kconfig
> +++ linux-2.6_dev/kernel/power/Kconfig
> @@ -131,3 +131,5 @@ config SUSPEND_SMP
>  	bool
>  	depends on HOTPLUG_CPU && X86 && PM
>  	default y
> +
> +source "kernel/power/fastoff/Kconfig"
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Why a separate, new Kconfig file?
Thought it would be cleaner.

> We shouldn't add a new Kconfig file for every new 1-2 kconfig symbols.
OK
> 
> 
> ---
> ~Randy
