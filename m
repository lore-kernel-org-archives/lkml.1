Return-Path: <linux-kernel-owner+w=401wt.eu-S934029AbYBNWhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934029AbYBNWhl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 17:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbYBNWhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 17:37:33 -0500
Received: from tomts36.bellnexxia.net ([209.226.175.93]:50212 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753222AbYBNWhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 17:37:32 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FANJRtEdMQWYv/2dsb2JhbACBWa10
Date: Thu, 14 Feb 2008 17:37:28 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make marker_debug static
Message-ID: <20080214223728.GA18772@Krystal>
References: <20080214212349.GD23227@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080214212349.GD23227@cs181133002.pp.htv.fi>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:37:06 up 3 days, 18:37,  2 users,  load average: 0.12, 0.23,
	0.41
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Adrian Bunk (bunk@kernel.org) wrote:
> With the needlessly global marker_debug being static gcc can optimize 
> the unused code away.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 

Thanks,

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

> ---
> 91577cc8ac60bf9003d0dd037a231db363003740 diff --git a/kernel/marker.c b/kernel/marker.c
> index c4c2cd8..133bdbb 100644
> --- a/kernel/marker.c
> +++ b/kernel/marker.c
> @@ -28,7 +28,7 @@ extern struct marker __start___markers[];
>  extern struct marker __stop___markers[];
>  
>  /* Set to 1 to enable marker debug output */
> -const int marker_debug;
> +static const int marker_debug;
>  
>  /*
>   * markers_mutex nests inside module_mutex. Markers mutex protects the builtin
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
