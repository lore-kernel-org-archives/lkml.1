Return-Path: <linux-kernel-owner+w=401wt.eu-S1161640AbXBOX1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161640AbXBOX1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 18:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161627AbXBOX1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 18:27:19 -0500
Received: from smtp.osdl.org ([65.172.181.24]:38549 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161640AbXBOX1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 18:27:18 -0500
Date: Thu, 15 Feb 2007 15:27:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] MAINTAINERS: mark framebuffer as Orphan
Message-Id: <20070215152708.2e4f8c8b.akpm@linux-foundation.org>
In-Reply-To: <20070215132549.c182f7bf.randy.dunlap@oracle.com>
References: <20070215132549.c182f7bf.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 13:25:49 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Are we ready to do this?
> I'd love for Tony to return, but he's been missing for awhile now.
> 
> So this give us the following major areas that are marked as Orphan:
> 
> Firmware loader
> Framebuffer
> Serial (8250/16x50)
> 
> and PCMCIA has a Team.  It doesn't seem to be hurting.  :)
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  MAINTAINERS |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> --- linux-2.6.20-git9.orig/MAINTAINERS
> +++ linux-2.6.20-git9/MAINTAINERS
> @@ -1321,11 +1321,9 @@ W:	http://www.farsite.co.uk/
>  S:	Supported
>  
>  FRAMEBUFFER LAYER
> -P:	Antonino Daplas
> -M:	adaplas@pol.net
>  L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
>  W:	http://linux-fbdev.sourceforge.net/
> -S:	Maintained
> +S:	Orphan

No, James is keeping an eye on things, but he obviously doesn't have as
much time to work on it as Tony did.

My point was that for bugs such as the one Pavel identified we're no longer
able to palm it off on the maintainer and expect magic to happen.  Either we
all dig in and help out or things don't get fixed.
