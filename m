Return-Path: <linux-kernel-owner+w=401wt.eu-S1759434AbXKTHDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434AbXKTHDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 02:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756624AbXKTHDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 02:03:07 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48035 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753908AbXKTHDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 02:03:05 -0500
Date: Mon, 19 Nov 2007 23:02:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/3] tty: Add the new termios2 ioctls to the compatible
 list.
Message-Id: <20071119230249.874ba094.akpm@linux-foundation.org>
In-Reply-To: <20071119125206.GA8623@osiris.boeblingen.de.ibm.com>
References: <20071119125206.GA8623@osiris.boeblingen.de.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007 13:52:06 +0100 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Make them depend on TCGETS2. If that one is implemented the rest
> should be there as well.
> 
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
> 
>  fs/compat_ioctl.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> Index: linux-2.6/fs/compat_ioctl.c
> ===================================================================
> --- linux-2.6.orig/fs/compat_ioctl.c
> +++ linux-2.6/fs/compat_ioctl.c
> @@ -1954,6 +1954,12 @@ ULONG_IOCTL(TIOCSCTTY)
>  COMPATIBLE_IOCTL(TIOCGPTN)
>  COMPATIBLE_IOCTL(TIOCSPTLCK)
>  COMPATIBLE_IOCTL(TIOCSERGETLSR)
> +#ifdef TCGETS2
> +COMPATIBLE_IOCTL(TCGETS2)
> +COMPATIBLE_IOCTL(TCSETS2)
> +COMPATIBLE_IOCTL(TCSETSW2)
> +COMPATIBLE_IOCTL(TCSETSF2)
> +#endif
>  /* Little f */
>  COMPATIBLE_IOCTL(FIOCLEX)
>  COMPATIBLE_IOCTL(FIONCLEX)

Should this be in 2.6.24?
