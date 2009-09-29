Return-Path: <linux-kernel-owner+w=401wt.eu-S1753720AbZI2Rrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbZI2Rrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 13:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbZI2Rrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 13:47:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:41904 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbZI2Rrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 13:47:45 -0400
Date: Tue, 29 Sep 2009 10:44:41 -0700
From: Greg KH <greg@kroah.com>
To: Andy Spencer <andy753421@gmail.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Permission masking security module (was dpriv)
Message-ID: <20090929174441.GE7209@kroah.com>
References: <20090923005644.GA28244@c.hsd1.tn.comcast.net> <20090929071010.GA17782@c.hsd1.tn.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090929071010.GA17782@c.hsd1.tn.comcast.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 07:10:10AM +0000, Andy Spencer wrote:
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -1771,7 +1771,7 @@ int vsscanf(const char * buf, const char * fmt, va_list args)
>  		 * advance both strings to next white space
>  		 */
>  		if (*fmt == '*') {
> -			while (!isspace(*fmt) && *fmt)
> +			while (!isspace(*fmt) && *fmt != '%' && *fmt)
>  				fmt++;
>  			while (!isspace(*str) && *str)
>  				str++;

What is this patch for?  Care to break it out separate with a different
changelog comment and push it upstream now if it is needed?

thanks,

greg k-h
