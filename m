Return-Path: <linux-kernel-owner+w=401wt.eu-S1753713AbZBSE3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbZBSE3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 23:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbZBSE3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 23:29:07 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:58060 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751851AbZBSE3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 23:29:06 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq0EAIZonElMQWt2/2dsb2JhbACBbtF2hBMG
Date: Wed, 18 Feb 2009 23:29:04 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, ltt-dev@lists.casi.polymtl.ca
Subject: Re: [PATCH 29/31] markers: Make static
Message-ID: <20090219042904.GI7956@Krystal>
References: <493EA286.7080500@gmail.com> <493EEFB6.3080901@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <493EEFB6.3080901@gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:28:39 up 49 days,  4:26,  3 users,  load average: 0.14, 0.20,
	0.26
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roel Kluin (roel.kluin@gmail.com) wrote:
> Sparse asked whether these could be static.
> 

Will merge in the LTTng tree, thanks !

Mathieu

> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  samples/markers/probe-example.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/samples/markers/probe-example.c b/samples/markers/probe-example.c
> index 2dfb3b3..d816aad 100644
> --- a/samples/markers/probe-example.c
> +++ b/samples/markers/probe-example.c
> @@ -20,7 +20,7 @@ struct probe_data {
>  	marker_probe_func *probe_func;
>  };
>  
> -void probe_subsystem_event(void *probe_data, void *call_data,
> +static void probe_subsystem_event(void *probe_data, void *call_data,
>  	const char *format, va_list *args)
>  {
>  	/* Declare args */
> @@ -37,9 +37,9 @@ void probe_subsystem_event(void *probe_data, void *call_data,
>  	/* or count, check rights, serialize data in a buffer */
>  }
>  
> -atomic_t eventb_count = ATOMIC_INIT(0);
> +static atomic_t eventb_count = ATOMIC_INIT(0);
>  
> -void probe_subsystem_eventb(void *probe_data, void *call_data,
> +static void probe_subsystem_eventb(void *probe_data, void *call_data,
>  	const char *format, va_list *args)
>  {
>  	/* Increment counter */
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
