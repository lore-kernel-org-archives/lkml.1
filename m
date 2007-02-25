Return-Path: <linux-kernel-owner+w=401wt.eu-S933651AbXBYFi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933651AbXBYFi4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 00:38:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933652AbXBYFiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 00:38:55 -0500
Received: from mail.kroah.org ([69.55.234.183]:48307 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933651AbXBYFiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 00:38:55 -0500
Date: Sat, 24 Feb 2007 21:37:46 -0800
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, marcel@holtmann.org
Subject: Re: 2.6.20-almost-rc1: usb oops during resume
Message-ID: <20070225053746.GA25058@kroah.com>
References: <20070224115137.GA8658@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070224115137.GA8658@elf.ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 24, 2007 at 12:51:37PM +0100, Pavel Machek wrote:
> Hi!
> 
> ...is it "use after free"?
> 
> Greg, could we reduce verbosity of driver model? "PM: Adding info for
> No Bus:vcs*" is not very useful.

Maybe for you it isn't, but then again, you did enable
CONFIG_DEBUG_DRIVER to see that, so you will get a lot of stuff in your
logs :)

thanks,

greg k-h
