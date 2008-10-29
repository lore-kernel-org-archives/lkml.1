Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567AbYJ2Sxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbYJ2Sxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 14:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753339AbYJ2Sxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 14:53:36 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:41493 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbYJ2Sxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 14:53:35 -0400
Date: Wed, 29 Oct 2008 19:54:48 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: include localarch for simple cross overrides
Message-ID: <20081029185448.GB22105@uranus.ravnborg.org>
References: <1225304495-28079-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225304495-28079-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 02:21:35PM -0400, Mike Frysinger wrote:
> For people banging on kernel trees which are dedicated to a specific arch,
> it'd be nice to allow the repo itself to declare the default ARCH (and
> CROSS_COMPILE) easily.  Just like the "localversion-*" files, people can
> just do:
> echo 'ARCH ?= blackfin' > localarch
> and the tree will default to 'blackfin' all the time rather than whatever
> the build machine happens to be.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  Makefile |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index a7f2068..7fa1f81 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -180,6 +180,7 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
>  # make ARCH=ia64
>  # Another way is to have ARCH set in the environment.
>  # The default ARCH is the host where make is executed.
> +-include localarch
>  
>  # CROSS_COMPILE specify the prefix used for all executables used
>  # during compilation. Only gcc and related bin-utils executables

Last time I did something similar it broke a few archs.
But then it was automatically done where this approach is mnually.

I will apply this to kbuild-next but it will most likely change
sometime in the future.

	Sam
