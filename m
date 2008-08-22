Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbYHVUBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbYHVUBr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 16:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbYHVUBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 16:01:40 -0400
Received: from blackbird.sr71.net ([64.146.134.44]:39163 "EHLO
	blackbird.sr71.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbYHVUBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 16:01:39 -0400
X-Greylist: delayed 1719 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Aug 2008 16:01:39 EDT
Subject: Re: [RFC v2][PATCH 1/9] Create trivial sys_checkpoint/sys_restart
	syscalls
From: Dave Hansen <dave@sr71.net>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: containers@lists.linux-foundation.org, jeremy@goop.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
In-Reply-To: <Pine.LNX.4.64.0808202302510.17436@takamine.ncl.cs.columbia.edu>
References: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu>
	 <Pine.LNX.4.64.0808202302510.17436@takamine.ncl.cs.columbia.edu>
Content-Type: text/plain
Date: Fri, 22 Aug 2008 12:32:58 -0700
Message-Id: <1219433578.20559.98.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-20 at 23:03 -0400, Oren Laadan wrote:
> 6/unistd_32.h
> index d739467..88bdec4 100644
> --- a/include/asm-x86/unistd_32.h
> +++ b/include/asm-x86/unistd_32.h
> @@ -338,6 +338,8 @@
>   #define __NR_dup3             330
>   #define __NR_pipe2            331
>   #define __NR_inotify_init1    332
> +#define __NR_checkpoint                333
> +#define __NR_restart           334
> 
>   #ifdef __KERNEL__

Uh oh.  These got whitespace mangled somehow.  I'll look through them,
but probably can't produce patches on top of them for now.

-- Dave

