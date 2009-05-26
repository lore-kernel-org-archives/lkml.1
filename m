Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbZEZPWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbZEZPWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 11:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754317AbZEZPVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 11:21:54 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:23789 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbZEZPVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 11:21:53 -0400
Message-ID: <4A1C0982.1090300@oracle.com>
Date: Tue, 26 May 2009 08:23:46 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: mingo@elte.hu, eduard.munteanu@linux360.ro, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemtrace: fix kernel parameter documentation
References: <alpine.DEB.2.00.0905241112190.10296@rocky>
In-Reply-To: <alpine.DEB.2.00.0905241112190.10296@rocky>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.4A1C08DD.01EB:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> The kmemtrace.enable kernel parameter no longer works. To enable
> kmemtrace at
> boot-time, you must pass "ftrace=kmemtrace" instead.

Can someone also list the possible tracers in the ftrace= area, please?

	ftrace=[tracer]
			[ftrace] will set and start the specified tracer
			as early as possible in order to facilitate early
			boot debugging.

Thanks.

> Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  Documentation/kernel-parameters.txt |   10 ----------
>  1 files changed, 0 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt
> b/Documentation/kernel-parameters.txt
> index e87bdbf..9243dd8 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -56,7 +56,6 @@ parameter is applicable:
>      ISAPNP    ISA PnP code is enabled.
>      ISDN    Appropriate ISDN support is enabled.
>      JOY    Appropriate joystick support is enabled.
> -    KMEMTRACE kmemtrace is enabled.
>      LIBATA  Libata driver is enabled
>      LP    Printer support is enabled.
>      LOOP    Loopback device support is enabled.
> @@ -1054,15 +1053,6 @@ and is between 256 and 4096 characters. It is
> defined in the file
>              use the HighMem zone if it exists, and the Normal
>              zone if it does not.
> 
> -    kmemtrace.enable=    [KNL,KMEMTRACE] Format: { yes | no }
> -                Controls whether kmemtrace is enabled
> -                at boot-time.
> -
> -    kmemtrace.subbufs=n    [KNL,KMEMTRACE] Overrides the number of
> -            subbufs kmemtrace's relay channel has. Set this
> -            higher than default (KMEMTRACE_N_SUBBUFS in code) if
> -            you experience buffer overruns.
> -
>      kgdboc=        [HW] kgdb over consoles.
>              Requires a tty driver that supports console polling.
>              (only serial suported for now)


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
