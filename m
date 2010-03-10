Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab0CJDQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 22:16:59 -0500
Received: from kroah.org ([198.145.64.141]:52269 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756113Ab0CJDQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 22:16:49 -0500
Date: Tue, 9 Mar 2010 18:54:11 -0800
From: Greg KH <greg@kroah.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-kernel@vger.kernel.org, lenz@cs.wisc.edu, rpurdie@openedhand.com
Subject: Re: private field in led_classdev?
Message-ID: <20100310025411.GD26642@kroah.com>
References: <20100307143112.GC5203@const.famille.thibault.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100307143112.GC5203@const.famille.thibault.fr>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 07, 2010 at 03:31:12PM +0100, Samuel Thibault wrote:
> Hello,
> 
> Would there be an objection to adding a void *private field to the
> led_classdev struct?  It would be a lot less burden for the input
> key board leds support for finding out the keyboard device from the
> brightness_set callback, as each device may have a long series of leds,
> not just a fixed number of them.

What's wrong with using the private pointer in the struct device
instead?  That's what it is there for.

thanks,

greg k-h
