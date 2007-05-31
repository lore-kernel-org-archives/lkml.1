Return-Path: <linux-kernel-owner+w=401wt.eu-S1761255AbXEaS1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761255AbXEaS1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 14:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758812AbXEaS1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 14:27:13 -0400
Received: from alnrmhc12.comcast.net ([204.127.225.92]:35789 "EHLO
	alnrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758641AbXEaS1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 14:27:12 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 May 2007 14:27:12 EDT
Subject: Re: [PATCH] Introduce O_CLOEXEC (take >2)
From: Nicholas Miell <nmiell@comcast.net>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       torvalds@linux-foundation.org
In-Reply-To: <200705311809.l4VI9F9X009556@devserv.devel.redhat.com>
References: <200705311809.l4VI9F9X009556@devserv.devel.redhat.com>
Content-Type: text/plain
Date: Thu, 31 May 2007 11:22:08 -0700
Message-Id: <1180635728.3104.3.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-31 at 14:09 -0400, Ulrich Drepper wrote:
> diff --git a/include/asm-generic/fcntl.h b/include/asm-generic/fcntl.h
> index c154b9d..b847741 100644
> --- a/include/asm-generic/fcntl.h
> +++ b/include/asm-generic/fcntl.h
> @@ -48,6 +48,9 @@
>  #ifndef O_NOATIME
>  #define O_NOATIME	01000000
>  #endif
> +#ifndef O_CLOEXEC
> +#define O_CLOEXEC	02000000	/* set close_on_exec */
> +#endif
>  #ifndef O_NDELAY
>  #define O_NDELAY	O_NONBLOCK
>  #endif

O_CLOSEONEXEC, perhaps?

We don't want to create another "creat" here... :)

-- 
Nicholas Miell <nmiell@comcast.net>

