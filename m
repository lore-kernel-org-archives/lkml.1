Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbYHYP4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbYHYP4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 11:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbYHYP4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 11:56:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:58559 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbYHYP4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 11:56:45 -0400
Date: Mon, 25 Aug 2008 08:49:46 -0700
From: Greg KH <greg@kroah.com>
To: ctuxer <ctuxer@gmail.com>
Cc: linux-kernel@vger.kernel.org, eerpini@gmail.com
Subject: Re: better support for EV-DO AC8700 800 M usbserial modem ??
Message-ID: <20080825154946.GA8628@kroah.com>
References: <op.ugdhwas9jwzwy4@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.ugdhwas9jwzwy4@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2008 at 09:41:33AM +0530, ctuxer wrote:
> hi everyone ,
>
> i have been using the EVDO AC8700 modem (usbserial) with kernel 2.6.26.2 , 
> it uses the 'option' module along with the generic usbserial module . Well 
> i am happy for the improved support for the modem handling in the new 
> kernels( like now i don have to modprobe with the vendor and product IDs ) 
> , there is one point specific to this modem which is still not handled , 
> ..... the modem switches between EVDO and CDMA mode when the signal 
> strength is low or when there is a bandwidth overload at the vendor's( the 
> service provider , bsnl in my case )  tower . This switch in the mode is 
> not recognised by the driver and the connection is lost once this switching 
> occurs . I have to restart the wvdial program to reconnect .
>
> But if the modem were in CDMA mode when i connect , then the connection is 
> not lost when the modem switches back from CDMA to EVDO . I really don know 
> enough to understand what is the difference between the two cases or what 
> can be done to improve the support for this usbserial modem , ... can 
> anyone help ?

This looks like something the userspace side has to handle, the option
driver is just a dumb "pass-through" type driver, it doesn't really
control the modem at all.  The "control" channel on the modem allows
this to happen, a userspace program drives this.

good luck,

greg k-h
