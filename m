Return-Path: <linux-kernel-owner+w=401wt.eu-S1761722AbZLLDw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761722AbZLLDw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 22:52:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761349AbZLLDw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 22:52:56 -0500
Received: from cantor.suse.de ([195.135.220.2]:38796 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129AbZLLDwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 22:52:55 -0500
Date: Fri, 11 Dec 2009 19:52:54 -0800
From: Greg KH <gregkh@suse.de>
To: David Miller <davem@davemloft.net>
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: usb_autopm_*() removal build failure...
Message-ID: <20091212035254.GB11096@suse.de>
References: <20091211.174551.123151540.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091211.174551.123151540.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 05:45:51PM -0800, David Miller wrote:
> 
> These routines are referenced by code in drivers/net/usb/kaweth.c and
> in a comment in drivers/net/wimax/i2400m/usb-tx.c
> 
> The former causes a build failure.
> 
> drivers/net/usb/kaweth.c: In function 'kaweth_open':
> drivers/net/usb/kaweth.c:719: error: implicit declaration of function 'usb_autopm_enable'
>   CC      lib/syscall.o
>   CC [M]  drivers/net/tokenring/tmspci.o
>   CC [M]  drivers/char/synclink_gt.o
> make[3]: *** [drivers/net/usb/kaweth.o] Error 1
> make[2]: *** [drivers/net/usb] Error 2
> make[2]: *** Waiting for unfinished jobs....
> 
> Just FYI...

That was resolved with a patch that Oliver sent you a while ago.  I'll
dig it up and resend it.

thanks,

greg k-h
