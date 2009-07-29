Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbZG2BBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbZG2BBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 21:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbZG2BBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 21:01:54 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35288 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769AbZG2BBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 21:01:53 -0400
Message-ID: <4A6F9F51.4010107@garzik.org>
Date: Tue, 28 Jul 2009 21:01:05 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
CC: paulus@samba.org, linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       linux-tip-commits@vger.kernel.org
Subject: Re: perf_counter: hook up the tracepoint events
References: <20090319194233.744044174@chello.nl> <tip-ee78a855ff4d8d3d77b46696994dca393228bb8a@git.kernel.org>
In-Reply-To: <tip-ee78a855ff4d8d3d77b46696994dca393228bb8a@git.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> diff --git a/init/Kconfig b/init/Kconfig
> index 8a38443..761129a 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -945,6 +945,11 @@ config PERF_COUNTERS
>  
>  	  Say Y if unsure.
>  
> +config EVENT_PROFILE
> +	bool "Tracepoint profile sources"
> +	depends on PERF_COUNTERS && EVENT_TRACER
> +	default y
> +
>  endmenu

Adding help text would be... helpful.   :)

The net result in this case was the addition of a completely-unexplained 
Kconfig option late in 2.6.31-rc.

Maybe the x86 maintainers could help see that they don't push 
unexplained Kconfig options upstream -- particularly ones we are asked 
to enable by default?

	Jeff



