Return-Path: <linux-kernel-owner+w=401wt.eu-S1751256AbZLWFh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256AbZLWFh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 00:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbZLWFh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 00:37:28 -0500
Received: from kroah.org ([198.145.64.141]:60302 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbZLWFh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 00:37:27 -0500
Date: Tue, 22 Dec 2009 21:37:34 -0800
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stefani Seibold <stefani@seibold.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Regression, 2.6.33-rc1->current git] NULL pointer in
	usb_serial_probe() introduced by the recent kfifo changes
Message-ID: <20091223053734.GC22808@kroah.com>
References: <200912230251.31568.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912230251.31568.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 02:51:31AM +0100, Rafael J. Wysocki wrote:
> Hi,
> 
> Something like the patch below is necessary to fix a new NULL pointer deref
> in usb_serial_probe() that appeared after the recent kfifo changes (in short,
> the kfifo changes modified the semantics of kfifo_alloc() that
> usb_serial_probe() reiled on).

What semantic changed?  I thought that the kfifo patches came with
patches that also fixed up any changed that were needed.  What went
wrong here?

Does your patch solve the oops?

thanks,

greg k-h
