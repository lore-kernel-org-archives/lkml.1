Return-Path: <linux-kernel-owner+w=401wt.eu-S1753789AbZDFFpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbZDFFpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 01:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbZDFFo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 01:44:29 -0400
Received: from kroah.org ([198.145.64.141]:47444 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752090AbZDFFo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 01:44:28 -0400
Date: Sun, 5 Apr 2009 22:37:53 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org
Subject: Re: USB: serial: add symbol serial driver
Message-ID: <20090406053753.GA12019@kroah.com>
References: <200903261929.n2QJTS5L009700@hera.kernel.org> <20090326194228.52087a47@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326194228.52087a47@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 07:42:28PM +0000, Alan Cox wrote:
> On Thu, 26 Mar 2009 19:29:28 GMT
> Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
> 
> Thank you for not running this past the tty layer maintainer.

Sorry about that.

> > +	/*
> > +	 * Force low_latency on so that our tty_push actually forces the data
> > +	 * through, otherwise it is scheduled, and with high data rates (like
> > +	 * with OHCI) data can get lost.
> > +	 */
> > +	if (tty)
> > +		tty->low_latency = 1;
> 
> The above is bogus cargo cult programming copied from old drivers and
> should be removed.

It's all over the usb-serial drivers, should I just remove it from all
of them?

thanks,

greg k-h
