Return-Path: <linux-kernel-owner+w=401wt.eu-S1760723AbZDCGrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760723AbZDCGrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 02:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759267AbZDCGrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 02:47:14 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:38604 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759223AbZDCGrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 02:47:13 -0400
Date: Fri, 3 Apr 2009 08:49:16 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harry Ciao <qingtao.cao@windriver.com>
Cc: git-commits-head@vger.kernel.org
Subject: Re: edac: AMD8111 driver Kconfig & Makefile
Message-ID: <20090403064916.GB13075@uranus.ravnborg.org>
References: <200904030503.n3353NJ2003427@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904030503.n3353NJ2003427@hera.kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 05:03:23AM +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/linus/58b4ce6f2422cf9eff50368462c204f1d95b7341
> Commit:     58b4ce6f2422cf9eff50368462c204f1d95b7341
> Parent:     e8765584156daef3e0ccd63dfa12466a8b75613d
> Author:     Harry Ciao <qingtao.cao@windriver.com>
> AuthorDate: Thu Apr 2 16:58:51 2009 -0700
> Committer:  Linus Torvalds <torvalds@linux-foundation.org>
> CommitDate: Thu Apr 2 19:05:04 2009 -0700
> 
>     edac: AMD8111 driver Kconfig & Makefile
>     
>     Introduce Kconfig and Makefile options for AMD8111 EDAC driver.
>     
>     Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
>     Cc: Doug Thompson <norsk5@yahoo.com>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  drivers/edac/Kconfig |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
> index 865cb7b..e5f5c5a 100644
> --- a/drivers/edac/Kconfig
> +++ b/drivers/edac/Kconfig
> @@ -197,4 +197,11 @@ config EDAC_AMD8131
>  	  Support for error detection and correction on the
>  	  AMD8131 HyperTransport PCI-X Tunnel chip.
>  
> +config EDAC_AMD8111
> +	tristate "AMD8111 HyperTransport I/O Hub"
> +	depends on EDAC_MM_EDAC && PCI
> +	help
> +	  Support for error detection and correction on the
> +	  AMD8111 HyperTransport I/O Hub chip.
> +
>  endif # EDAC

Was the changes to the Makefile lost somehow?

	Sam
