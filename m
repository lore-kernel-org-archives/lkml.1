Return-Path: <linux-kernel-owner+w=401wt.eu-S1756266AbZFCHry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbZFCHry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 03:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbZFCHrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 03:47:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34667 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753263AbZFCHrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 03:47:46 -0400
Date: Wed, 3 Jun 2009 08:42:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: leemgs1@gmail.com
Cc: Jiri Kosina <trivial@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, dougthompson@xmission.com
Subject: Re: [PATCH] Fix the meaning of EDAC abbreviation
Message-ID: <20090603084253.1a0aa5b0@lxorguk.ukuu.org.uk>
In-Reply-To: <1243987469.20635.69.camel@centos51>
References: <1243987469.20635.69.camel@centos51>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Fix the meaning of EDAC(Error Detection And Correction) correctly.
>  - http://bluesmoke.sourceforge.net
> 
>         Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
> ---
>  drivers/edac/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
> index 956982f..2a81915 100644
> --- a/drivers/edac/Kconfig
> +++ b/drivers/edac/Kconfig
> @@ -5,7 +5,7 @@
>  #
>  
>  menuconfig EDAC
> -	bool "EDAC - error detection and reporting"
> +	bool "EDAC - Error Detection And Correction"

The code started off as one thing and acquired its name but a primary
function of it now is indeed reporting rather than just correction. The
name has stuck but the functionality doesn't quite match - so the
existing menuconfig entry is actually more helpful.
