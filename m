Return-Path: <linux-kernel-owner+w=401wt.eu-S939274AbXG3Tem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939274AbXG3Tem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938989AbXG3TeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:34:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35541 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937192AbXG3TeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:34:19 -0400
Date: Mon, 30 Jul 2007 12:33:39 -0700
From: Greg KH <greg@kroah.com>
To: Adam Kropelin <akropel1@rochester.rr.com>
Cc: Nick Pasich <NewsLetters@NickAndBarb.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-usb-devel @ lists. sourceforge. net" 
	<linux-usb-devel@lists.sourceforge.net>,
       Al Borchers <alborchers@steinerpoint.com>,
       "linux-kernel @ vger. kernel. org" <linux-kernel@vger.kernel.org>,
       Peter Berger <pberger@brimson.com>
Subject: Re: [PATCH] usb-serial: Fix edgeport regression on non-EPiC devices
Message-ID: <20070730193339.GA31969@kroah.com>
References: <20070729150329.GA14873@mail.kroptech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070729150329.GA14873@mail.kroptech.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 11:03:29AM -0400, Adam Kropelin wrote:
> Fix serious regression on non-EPiC edgeport usb-serial devices. Baud 
> rate and MCR/LCR registers are not being written on these models due 
> to apparent copy-n-paste errors introduced with EPiC support.
> 
> Failure reported by Nick Pasich <Nick@NickAndBarb.net>.
> 
> Signed-off-by: Adam Kropelin <akropel1@rochester.rr.com>

Ugh, good catch on this one, sorry, it was my fault when I added the
epic support.

I'll apply this to the proper trees now and send it onward...

thanks,

greg k-h
