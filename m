Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbYDSB5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbYDSB5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 21:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbYDSB5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 21:57:15 -0400
Received: from hpsmtp-eml17.kpnxchange.com ([213.75.38.117]:45147 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751788AbYDSB5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 21:57:13 -0400
From: Frans Pop <elendil@planet.nl>
To: Yinghai Lu <yhlu.kernel.send@gmail.com>
Subject: Re: [PATCH] x86_64: simplify the memtest parameter setting
Date: Sat, 19 Apr 2008 03:57:07 +0200
User-Agent: KMail/1.9.9
Cc: mingo@elte.hu, akpm@linux-foundation.org, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
References: <200804181749.15782.yhlu.kernel@gmail.com>
In-reply-To: <200804181749.15782.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804190357.09243.elendil@planet.nl>
X-OriginalArrivalTime: 19 Apr 2008 01:57:12.0414 (UTC) FILETIME=[AF22B7E0:01C8A1C0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> -config MEMTEST_BOOTPARAM
> -	bool "Memtest boot parameter"
> +config MEMTEST
> +	bool "Memtest"
>  depends on X86_64
>  default y

With this patch, this default no longer makes any sense.

>  help
>  This option adds a kernel parameter 'memtest', which allows memtest
> -	  to be disabled at boot.  If this option is selected, memtest
> -	  functionality can be disabled with memtest=0 on the kernel
> -	  command line.  The purpose of this option is to allow a single
> -	  kernel image to be distributed with memtest built in, but not
> -	  necessarily enabled.
> -
> +	  to be set.
> +		memtest=0, mean disabled; -- default
> +		memtest=1, mean do 1 test pattern;
> +		...
> +		memtest=4, mean do 4 test patterns.

s/mean/means/
s/; -- default/ (default)/ although that does not really make sense either

Maybe some explanation of what a "test pattern" is would be useful.

>  If you are unsure how to answer this question, answer Y.

Also makes no sense anymore.

Cheers,
FJP
