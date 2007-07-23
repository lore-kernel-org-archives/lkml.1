Return-Path: <linux-kernel-owner+w=401wt.eu-S1764344AbXGWX6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764344AbXGWX6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 19:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbXGWX6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 19:58:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52568 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752432AbXGWX6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 19:58:35 -0400
Date: Mon, 23 Jul 2007 16:58:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] Kconfig:  Remove top level menu "Code maturity level
 options"
Message-Id: <20070723165813.20848a85.akpm@linux-foundation.org>
In-Reply-To: <200707210658.28241.a1426z@gawab.com>
References: <200707210658.28241.a1426z@gawab.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2007 06:58:28 +0300
Al Boldi <a1426z@gawab.com> wrote:

> 
> This patch removes the top level menu "Code maturity level options", and 
> moves its options into menu "General setup".
> 
> This makes Kconfig less cluttered and easier to setup.
> 
> 
> Cc: Andrew Morton <akpm@osdl.org>
> Signed-off-by: Al Boldi <a1426z@gawab.com>
> 
> ---
> --- a/init/Kconfig	2007-07-09 06:38:47.000000000 +0300
> +++ b/init/Kconfig	2007-07-21 06:42:06.000000000 +0300
> @@ -7,7 +7,7 @@ config DEFCONFIG_LIST
>  	default "/boot/config-$UNAME_RELEASE"
>  	default "arch/$ARCH/defconfig"
>  
> -menu "Code maturity level options"
> +menu "General setup"
>  
>  config EXPERIMENTAL
>  	bool "Prompt for development and/or incomplete code/drivers"
> @@ -61,9 +61,6 @@ config INIT_ENV_ARG_LIMIT
>  	  Maximum of each of the number of arguments and environment
>  	  variables passed to init from the kernel command line.
>  
> -endmenu
> -
> -menu "General setup"
>  
>  config LOCALVERSION
>  	string "Local version - append to kernel release"

OK (IMO).  The "Code maturity level options" menu only has a single
entry, and I doubt if it will grow more entries any time soon.  It
makes sense to kill it and to move its sole entry into "General setup".
