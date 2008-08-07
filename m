Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbYHGCMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbYHGCMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 22:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbYHGCMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 22:12:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:42920 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbYHGCMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 22:12:21 -0400
Date: Wed, 6 Aug 2008 17:05:02 -0700
From: Greg KH <greg@kroah.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Oliver Neukum <oliver@neukum.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] usb: cdc-acm: flags passed to spin_lock_irqsave must
	be unsigned
Message-ID: <20080807000502.GA8748@kroah.com>
References: <20080803165011.GB5414@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080803165011.GB5414@joi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2008 at 06:50:14PM +0200, Marcin Slusarz wrote:
> gcc warned about it:
> drivers/usb/class/cdc-acm.c: In function 'acm_waker':
> drivers/usb/class/cdc-acm.c:527: warning: comparison of distinct pointer types lacks a cast
> drivers/usb/class/cdc-acm.c:529: warning: comparison of distinct pointer types lacks a cast
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Oliver Neukum <oliver@neukum.org>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>

Just got this fix from someone else first, sorry, but thanks for the
patch.

greg k-h
