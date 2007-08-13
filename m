Return-Path: <linux-kernel-owner+w=401wt.eu-S965839AbXHMUl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965839AbXHMUl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965016AbXHMUkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:40:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37598 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S947105AbXHMUkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:40:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: joe@perches.com
Subject: Re: [PATCH] [443/2many] MAINTAINERS - HIBERNATION (aka Software Suspend, aka swsusp):
Date: Mon, 13 Aug 2007 22:50:14 +0200
User-Agent: KMail/1.9.5
Cc: torvalds@linux-foundation.org, pavel@suse.cz,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <46bffbd3.IqsNHrHU1Y9BF7Dd%joe@perches.com>
In-Reply-To: <46bffbd3.IqsNHrHU1Y9BF7Dd%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708132250.15466.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 13 August 2007 08:36, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 29a2179..5ae90a2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4215,6 +4215,9 @@ P:	Rafael J. Wysocki
>  M:	rjw@sisk.pl
>  L:	linux-pm@lists.linux-foundation.org
>  S:	Supported
> +F:	Documentation/power/swsusp*
> +F:	arch/i386/power/swsusp.S
> +F:	kernel/power/

Well, the list isn't complete.  Please add

arch/i386/power/
arch/x86_64/kernel/suspend_asm.S
arch/x86_64/kernel/suspend.c
drivers/base/power/

There also is a couple of headers.  Do you want to list them too?

>  
>  SUSPEND TO RAM:
>  P:	Pavel Machek
> 
> 

Greetings,
Rafael

-- 
"Premature optimization is the root of all evil." - Donald Knuth
