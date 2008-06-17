Return-Path: <linux-kernel-owner+w=401wt.eu-S1759117AbYFQOB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759117AbYFQOB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 10:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757362AbYFQOBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 10:01:19 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:43634 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755912AbYFQOBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 10:01:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvIEAL1cV0hMQW1O/2dsb2JhbACBW60T
Date: Tue, 17 Jun 2008 10:01:13 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: tzanussi@gmail.com, linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 1/3] Unignore vmlinux.lds.h from Git.
Message-ID: <20080617140113.GC10316@Krystal>
References: <20080615180501.1181e659@linux360.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080615180501.1181e659@linux360.ro>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:00:13 up 12 days, 18:41,  4 users,  load average: 0.56, 0.62,
	0.46
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eduard - Gabriel Munteanu (eduard.munteanu@linux360.ro) wrote:
> Added !vmlinux.lds.h to .gitignore because it would otherwise be ignored.
> 
> Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>

Yep, the "vmlinux*" entry seems to match vmlinux.lds.h, it shouldn't.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

> ---
>  .gitignore |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/.gitignore b/.gitignore
> index d24ad50..9bb1cb6 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -26,6 +26,7 @@ tags
>  TAGS
>  vmlinux*
>  !vmlinux.lds.S
> +!vmlinux.lds.h
>  System.map
>  Module.markers
>  Module.symvers
> -- 
> 1.5.5.4
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
