Return-Path: <linux-kernel-owner+w=401wt.eu-S1760169AbYDOPvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760169AbYDOPvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 11:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbYDOPvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 11:51:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57498 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbYDOPvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 11:51:25 -0400
Date: Mon, 14 Apr 2008 22:29:18 -0700
From: Greg KH <greg@kroah.com>
To: Reynes Philippe <tremyfr@yahoo.fr>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [MM snapshot] fix undeclared hcd in ohci-sm501.c
Message-ID: <20080415052918.GC23965@kroah.com>
References: <419605.88113.qm@web27901.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <419605.88113.qm@web27901.mail.ukl.yahoo.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 12:08:43AM +0200, Reynes Philippe wrote:
> The function ohci_sm501_resume in drivers/usb/host/ohci-hcd.c use the
> variable hcd, but this variable is undeclared in this function, so the compilation 
> fails with this error :
> 
>   CC      drivers/usb/host/ohci-hcd.o
> In file included from drivers/usb/host/ohci-hcd.c:1056:
> drivers/usb/host/ohci-sm501.c: In function ?ohci_sm501_resume?:
> drivers/usb/host/ohci-sm501.c:241: erreur: ?hcd? undeclared (first use in this function)
> drivers/usb/host/ohci-sm501.c:241: erreur: (Each undeclared identifier is reported only once
> drivers/usb/host/ohci-sm501.c:241: erreur: for each function it appears in.)
> make[3]: *** [drivers/usb/host/ohci-hcd.o] Erreur 1
> make[2]: *** [drivers/usb/host] Erreur 2
> make[1]: *** [drivers/usb] Erreur 2
> make: *** [drivers] Erreur 2

I just merged a patch from Alan Stern into my tree that should fix this.
Check the linux-next tree tomorrow to verify that it made it in.

thanks,

greg k-h
