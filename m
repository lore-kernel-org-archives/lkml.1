Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbYEOTvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbYEOTvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758167AbYEOTuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:50:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50667 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757870AbYEOTuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:50:18 -0400
Date: Thu, 15 May 2008 11:44:24 -0700
From: Greg KH <greg@kroah.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       video4linux-list@redhat.com
Subject: Re: [PATCH] USB: add Sensoray 2255 v4l driver
Message-ID: <20080515184424.GD15231@kroah.com>
References: <20080514205927.GA13134@kroah.com> <200805151338.38801.oliver@neukum.org> <200805151403.19323.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805151403.19323.oliver@neukum.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 02:03:18PM +0200, Oliver Neukum wrote:
> Am Donnerstag 15 Mai 2008 13:38:37 schrieb Oliver Neukum:
> > 3. The firmware stuff. That's an interesting solution. However:
> 
> Actually, on second thought, I take that back. It's a bad solution.
> If you don't want to do it in probe(), the only other sensible place
> is in open(). That way you can avoid the whole trouble if nobody
> opens the device. And you need to handle the case of unloaded
> firmware anyway, so you can trigger firmware load there.

No, we want to do firmware load on probe, I'll change it to be async so
that probe can continue on.  Need to see if I can disconnect the driver
from device after probe succeeds in case the firmware fails.

thanks for the review, I appreciate it and will fix them up later today
or tomorrow.

greg k-h
