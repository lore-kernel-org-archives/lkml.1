Return-Path: <linux-kernel-owner+w=401wt.eu-S1759499AbZBCAHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499AbZBCAHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 19:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754896AbZBCAHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 19:07:04 -0500
Received: from kroah.org ([198.145.64.141]:34893 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754673AbZBCAHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 19:07:02 -0500
Date: Mon, 2 Feb 2009 16:05:29 -0800
From: Greg KH <greg@kroah.com>
To: Chuck Ebbert <cebbert@redhat.com>, dan williams <dcbw@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable]  A patch in 2.6.27.9 caused device names to change
Message-ID: <20090203000529.GC9467@kroah.com>
References: <20090202170238.348af36a@dhcp-100-2-144.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090202170238.348af36a@dhcp-100-2-144.bos.redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 02, 2009 at 05:02:38PM -0500, Chuck Ebbert wrote:
> This patch:
> http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob_plain;f=releases/2.6.27.9/usb-option-add-pantech-cards.patch;hb=HEAD
> 
> replaced my wireless adapter's /dev/ttyACM0 interface with three interfaces:
> /dev/ttyUSB[012]
> 
> That broke my ppp connection scripts. And I have to use /dev/ttyUSB1 to connect,
> not USB0. Also it looks like Network Manager only knows how to use the first
> interface in its auto-connect mode, so people using that also lost their
> connections.

Ugh, that sucks.

That is what is also in upstream, so 2.6.29-rc also fails for you?

Dan, what's with replacing working devices with the cdc-acm driver with
option device ids?  Is there some reason you did this?

thanks,

greg k-h
