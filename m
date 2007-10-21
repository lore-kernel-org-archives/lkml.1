Return-Path: <linux-kernel-owner+w=401wt.eu-S1751655AbXJUEJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbXJUEJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 00:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbXJUEJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 00:09:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52243 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbXJUEJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 00:09:50 -0400
Date: Sat, 20 Oct 2007 21:07:57 -0700
From: Greg KH <greg@kroah.com>
To: Timur Tabi <timur@freescale.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: request_firmware() and in-kernel modules
Message-ID: <20071021040757.GC24869@kroah.com>
References: <4718EAEA.9000609@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4718EAEA.9000609@freescale.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2007 at 12:35:38PM -0500, Timur Tabi wrote:
> If my driver is compiled in-kernel (and I have module support turned off), 
> can I still use request_firmware()?

Yes.

> If my driver is loaded before the file system drivers are loaded, how
> can a user process copy the firmware to the
> /sys/class/firwmare/.../data device?

I'd recommend using the non-blocking mode, that way, when userspace
finally gets running, it can handle the firmware events properly, and
your kernel code will have not timed out already.

thanks,

greg k-h
