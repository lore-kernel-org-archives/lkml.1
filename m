Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbYL1GJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbYL1GJy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 01:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbYL1GJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 01:09:45 -0500
Received: from kroah.org ([198.145.64.141]:52433 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751196AbYL1GJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 01:09:45 -0500
Date: Sat, 27 Dec 2008 22:05:33 -0800
From: Greg KH <greg@kroah.com>
To: Tigran Grigoryan <tigrangr@synopsys.COM>
Cc: linux-kernel@vger.kernel.org
Subject: Re: usb_create_hcd calls dev_set_drvdata
Message-ID: <20081228060533.GA5118@kroah.com>
References: <006501c96803$bb2f4e40$318deac0$@com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <006501c96803$bb2f4e40$318deac0$@com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2008 at 01:15:59PM +0400, Tigran Grigoryan wrote:
> Hi,
> 
> Why usb_create_hcd calls dev_set_drvdata and never uses that data.

Are you sure about that?

> OTG device drivers may want to set their own data.

Yes, and is this a problem?

I'm confused to what exactly is wrong here.  Does the new OTG drivers
not work for you, or are you writing a new one?

thanks,

greg k-h
