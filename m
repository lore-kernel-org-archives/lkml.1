Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbZKQB4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbZKQB4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 20:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755452AbZKQB4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 20:56:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41050 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755214AbZKQB4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 20:56:51 -0500
Date: Mon, 16 Nov 2009 17:38:19 -0800
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>, Alon Bar-Lev <alon.barlev@gmail.com>,
       David Vrabel <david.vrabel@csr.com>, linux-usb@vger.kernel.org
Subject: Re: [PATCH 10/12] usbdevfs: move compat_ioctl handling to devio.c
Message-ID: <20091117013819.GA8030@suse.de>
References: <1258331227-1694-1-git-send-email-arnd@arndb.de>
 <1258331227-1694-11-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258331227-1694-11-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 12:27:05AM +0000, Arnd Bergmann wrote:
> Half the compat_ioctl handling is in devio.c, the other
> half is in fs/compat_ioctl.c. This moves everything into
> one place for consistency.
> 
> As a positive side-effect, push down the BKL into the
> ioctl methods.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Oliver Neukum <oliver@neukum.org>
> Cc: Alon Bar-Lev <alon.barlev@gmail.com>
> Cc: David Vrabel <david.vrabel@csr.com>
> Cc: linux-usb@vger.kernel.org

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

thanks for doing this.

greg k-h
