Return-Path: <linux-kernel-owner+w=401wt.eu-S1760008AbYBUU7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760008AbYBUU7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 15:59:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760182AbYBUU6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 15:58:49 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46162 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757660AbYBUU6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 15:58:48 -0500
Date: Thu, 21 Feb 2008 12:58:16 -0800
From: Greg KH <greg@kroah.com>
To: David Newall <davidn@davidnewall.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Handshaking on USB serial devices
Message-ID: <20080221205816.GA23793@kroah.com>
References: <47B30291.2040905@davidnewall.com> <20080214050211.GB1432@kroah.com> <47B40918.20206@davidnewall.com> <20080214121026.16a9c510@core> <47B482B4.9010208@davidnewall.com> <20080214193637.5df1c205@core> <47BD9721.70907@davidnewall.com> <20080221151549.0fa72422@core> <47BDD26D.5010004@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BDD26D.5010004@davidnewall.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 06:05:09AM +1030, David Newall wrote:
> Alan Cox wrote:
> >> developing is entirely wrong.  Oh well.  Mind you, providing a
> >> write_room function is NOT a real solution; it merely reduces the
> >> condition to a usually-winnable race.  (Ironically, when I back-ported
> >> the 2.6 driver, I excluded its new write_room function.  Mistake.)
> >>     
> >
> > What race do you see left ?
> >   
> 
> On second thoughts I'm not sure that I do.  I've had my head so full of
> 2.4 pl2303, and 2.4 pl2303 with this, that and the other added to it,
> that I was probably just confused.  Certainly it's not important,
> because I didn't mean the 2.6 driver, but an hypothetical 2.4 with a
> simplistic write_room function added (e.g. return
> port->write_urb->status == -EINPROGRESS ? 0 : 64).  OPOST processing's
> use of putchar to expand CRLF sends two writes (or putchars), with no
> intervening checks.  Since I'm just polishing off my back-port of
> 2.6.24.1 pl2303 to kernel 2.4, the matter is quite irrelevant.
> 
> By the way, what happened to HUawei E620 UMTS/HSDPA card?  It's in
> pl2303 in 2.6.23; not in 2.6.24.1.  (Do I remove it from my back-port?)

Yes, please remove it, it was incorrectly listed in the pl2303 driver in
the .23 kernel.

thanks,

greg k-h
