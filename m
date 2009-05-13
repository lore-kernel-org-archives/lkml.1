Return-Path: <linux-kernel-owner+w=401wt.eu-S1759887AbZEMOjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887AbZEMOjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 10:39:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756241AbZEMOiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 10:38:52 -0400
Received: from kroah.org ([198.145.64.141]:53633 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942AbZEMOiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 10:38:51 -0400
Date: Wed, 13 May 2009 07:35:36 -0700
From: Greg KH <greg@kroah.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb-serial: ftdi: don't dereference NULL pointer
Message-ID: <20090513143536.GA3443@kroah.com>
References: <1242213703-3004-1-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242213703-3004-1-git-send-email-daniel@caiaq.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 01:21:43PM +0200, Daniel Mack wrote:
> The FTDI USB serial driver dereferences its priv structure in
> ftdi_close() without checking for NULL pointer conditions, see the Oops
> attached.

Hm, I think this was already resolved with Alan's patch that went in
right after 2.6.30-rc5 came out.  Can you check Linus's current tree to
see if we still need this patch or not?

thanks,

greg k-h
