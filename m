Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab0BOPmM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 10:42:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50631 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755689Ab0BOPmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 10:42:09 -0500
Date: Mon, 15 Feb 2010 07:41:58 -0800
From: Greg KH <gregkh@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       devel@driverdev.osuosl.org, Phil Hannent <phil@hannent.co.uk>,
       mwilder@cs.nmsu.edu, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH] staging: mimio, add extra sync to down-up input events
Message-ID: <20100215154158.GA22102@suse.de>
References: <1266179821-900-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266179821-900-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 14, 2010 at 09:37:01PM +0100, Jiri Slaby wrote:
> Userspace is allowed to coalesce events between SYNCs. And since the code
> emits UP right after DOWN for the same key, it may be missed
> (up+down=nothing). Add an extra sync in between UP and DOWN events to disable
> the coalesce.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: devel@driverdev.osuosl.org
> Cc: Phil Hannent <phil@hannent.co.uk>
> Cc: <mwilder@cs.nmsu.edu>
> Cc: Dmitry Torokhov <dtor@mail.ru>
> ---
>  drivers/staging/mimio/mimio.c |    6 ++++++

Heh, I just deleted this driver from the staging tree, and it's gone in
linux-next, as the company now has a libusb version that works
cross-platform without any kernel changes needed.

So thanks for the patch, but it is no longer needed :)

greg k-h
