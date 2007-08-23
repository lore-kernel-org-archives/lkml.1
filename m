Return-Path: <linux-kernel-owner+w=401wt.eu-S932277AbXHWVNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277AbXHWVNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 17:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757434AbXHWVM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 17:12:58 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35459 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756950AbXHWVM6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 17:12:58 -0400
Date: Thu, 23 Aug 2007 14:11:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: andre@finow14.de, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [patch 1/1] fix a trivial typo in scripts/checkstack.pl
Message-Id: <20070823141116.87b10f84.akpm@linux-foundation.org>
In-Reply-To: <20070823131302.GA24870@lazybastard.org>
References: <20070823125227.294913273@finow14.de>
	<20070823125540.GA19389@ahaupt-debian-vm.localdomain>
	<20070823131302.GA24870@lazybastard.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2007 15:13:02 +0200
Jörn Engel <joern@logfs.org> wrote:

> Trivial change in a comment.
> 
> Signed-off-by: Jörn Engel <joern@logfs.org>
> Signed-off-by: Andre Haupt <andre@finow14.de>
> ---
> Index: linus/scripts/checkstack.pl
> ===================================================================
> --- linus.orig/scripts/checkstack.pl	2007-08-23 14:25:03.000000000 +0200
> +++ linus/scripts/checkstack.pl	2007-08-23 14:42:13.000000000 +0200
> @@ -14,7 +14,7 @@
>  #	M68k port by Geert Uytterhoeven and Andreas Schwab
>  #
>  #	Usage:
> -#	objdump -d vmlinux | stackcheck.pl [arch]
> +#	objdump -d vmlinux | scripts/checkstack.pl [arch]
>  #
>  #	TODO :	Port to all architectures (one regex per arch)

Thanks, I forwarded this to Andy.  I prefer not to apply checkpatch
patches directly to -mm as it's still under a considerable amount of
development and anything which I apply would just get tangled up with
Andy's next update.
