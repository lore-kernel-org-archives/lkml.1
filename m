Return-Path: <linux-kernel-owner+w=401wt.eu-S1760071AbZDCGou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760071AbZDCGou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 02:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757849AbZDCGol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 02:44:41 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:37524 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbZDCGok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 02:44:40 -0400
Date: Fri, 3 Apr 2009 08:46:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Sandeen <sandeen@redhat.com>
Cc: git-commits-head@vger.kernel.org
Subject: Re: add fiemap.h to header-y
Message-ID: <20090403064640.GA13075@uranus.ravnborg.org>
References: <200904030459.n334xVpS019935@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904030459.n334xVpS019935@hera.kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 04:59:31AM +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/linus/8e2c3795c78d5c4e2e1f14ce751e9d08decbe9d3
> Commit:     8e2c3795c78d5c4e2e1f14ce751e9d08decbe9d3
> Parent:     c90bfeb80f00c765a57f17442fea1a57756b9034
> Author:     Eric Sandeen <sandeen@redhat.com>
> AuthorDate: Thu Apr 2 16:56:44 2009 -0700
> Committer:  Linus Torvalds <torvalds@linux-foundation.org>
> CommitDate: Thu Apr 2 19:04:49 2009 -0700
> 
>     add fiemap.h to header-y
>     
>     Include fiemap.h in header-y; it defines the interface for the
>     FS_IOC_FIEMAP file mapping ioctl.
>     
>     Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  include/linux/Kbuild |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/Kbuild b/include/linux/Kbuild
> index a67b622..ca9b9b9 100644
> --- a/include/linux/Kbuild
> +++ b/include/linux/Kbuild
> @@ -67,6 +67,7 @@ header-y += falloc.h
>  header-y += fd.h
>  header-y += fdreg.h
>  header-y += fib_rules.h
> +header-y += fiemap.h
>  header-y += firewire-cdev.h
>  header-y += firewire-constants.h
>  header-y += fuse.h

Before adding a new headers as an exported headers please fix it up.
This headers uses __u32/__u64 but fails to include <linux/types.h>

	Sam
