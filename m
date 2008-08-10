Return-Path: <linux-kernel-owner+w=401wt.eu-S1754906AbYHJBos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbYHJBos (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 21:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbYHJBoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 21:44:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:58518 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbYHJBoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 21:44:38 -0400
Date: Sat, 9 Aug 2008 18:38:08 -0700
From: Greg KH <greg@kroah.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [00/03] [RFC] USB debugging rework
Message-ID: <20080810013808.GA15828@kroah.com>
References: <20080809013820.GA10910@kroah.com> <200808100057.58863.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808100057.58863.elendil@planet.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2008 at 12:57:58AM +0200, Frans Pop wrote:
> Greg KH wrote:
> > I've been annoyed for a long time that we make users go off and rebuild
> > their kernels just to enable usb debug messages.  So finally, here's the
> > start of fixing that issue.
> 
> Will your patches also allow to turn off the usb debugging at some point, 

Yes, you can do that right now with them, just change the value at
/sys/module/usbcore/paramaters/debug and debugging is disabled on the
fly.

thanks,

greg k-h
