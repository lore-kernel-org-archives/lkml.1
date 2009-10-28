Return-Path: <linux-kernel-owner+w=401wt.eu-S1752538AbZJ1SIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbZJ1SIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 14:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbZJ1SIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 14:08:35 -0400
Received: from kroah.org ([198.145.64.141]:42080 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbZJ1SIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 14:08:34 -0400
Date: Wed, 28 Oct 2009 11:05:44 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Dropped characters in serial connection without flow control
Message-ID: <20091028180544.GA3523@kroah.com>
References: <20091028175937.27472.qmail@stuge.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028175937.27472.qmail@stuge.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 06:59:37PM +0100, Peter Stuge wrote:
> Peter Stuge wrote:
> > I'm writing a line discipline for a serial port multiplexing
> > hardware
> 
> There is no(!) support for flow control in the hardware.
> 
> Is there anything I can do to reduce serial port interrupt latency or
> otherwise try to mitigate this in my ldisc or in Linux in general? I
> realize that it will never be quite reliable without any flow
> control.

What's wrong with XON/XOFF?  That is a well-known flow control protocol
for systems without hardware support for it.

And since when is adding a UART to a hardware chip expensive these days?

thanks,

greg k-h
