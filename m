Return-Path: <linux-kernel-owner+w=401wt.eu-S1759190AbZD0SaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759190AbZD0SaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758908AbZD0S3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:29:48 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:44386 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758909AbZD0S3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:29:47 -0400
Date: Mon, 27 Apr 2009 20:31:53 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/8] frv: Remove unused header asm/init.h.
Message-ID: <20090427183153.GA12056@uranus.ravnborg.org>
References: <1240855347-19316-1-git-send-email-tabbott@mit.edu> <1240855347-19316-2-git-send-email-tabbott@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240855347-19316-2-git-send-email-tabbott@mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 02:02:20PM -0400, Tim Abbott wrote:
> It seems nothing has included the frv asm/init.h header for some time,
> and its actual contents are out of date with include/linux/init.h.  So
> just delete it.

git grep 'asm/init.h' agree with you.

> 
> Signed-off-by: Tim Abbott <tabbott@mit.edu>
> Cc: David Howells <dhowells@redhat.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
> ---
>  arch/frv/include/asm/init.h |   12 ------------
>  1 files changed, 0 insertions(+), 12 deletions(-)
>  delete mode 100644 arch/frv/include/asm/init.h
> 
> diff --git a/arch/frv/include/asm/init.h b/arch/frv/include/asm/init.h
> deleted file mode 100644
> index 8b15838..0000000
> --- a/arch/frv/include/asm/init.h
> +++ /dev/null
> @@ -1,12 +0,0 @@
> -#ifndef _ASM_INIT_H
> -#define _ASM_INIT_H
> -
> -#define __init __attribute__ ((__section__ (".text.init")))
> -#define __initdata __attribute__ ((__section__ (".data.init")))
> -/* For assembly routines */
> -#define __INIT		.section	".text.init",#alloc,#execinstr
> -#define __FINIT		.previous
> -#define __INITDATA	.section	".data.init",#alloc,#write
> -
> -#endif
> -
> -- 
> 1.6.2.1
> 
