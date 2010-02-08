Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab0BHWek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 17:34:40 -0500
Received: from kroah.org ([198.145.64.141]:45729 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294Ab0BHWeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 17:34:36 -0500
Date: Sun, 7 Feb 2010 20:49:17 -0800
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb <linux-usb@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/usb: Convert concatenated __FILE__ to %s,
	__FILE__
Message-ID: <20100208044917.GC30314@kroah.com>
References: <1265421073.10226.56.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265421073.10226.56.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 05, 2010 at 05:51:13PM -0800, Joe Perches wrote:
> Reduces string space a bit

It does?  Does gcc optimize all of the __FILE__ instances to point to
the same place in the object?

thanks,

greg k-h
