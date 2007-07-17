Return-Path: <linux-kernel-owner+w=401wt.eu-S1763666AbXGQGl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763666AbXGQGl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 02:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756445AbXGQGlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 02:41:51 -0400
Received: from canuck.infradead.org ([209.217.80.40]:56365 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014AbXGQGlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 02:41:50 -0400
Date: Mon, 16 Jul 2007 23:12:18 -0700
From: Greg KH <greg@kroah.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 30/33] USB storage: sg chaining support
Message-ID: <20070717061218.GA16976@kroah.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com> <11845792692184-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11845792692184-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2007 at 11:47:44AM +0200, Jens Axboe wrote:
> [PATCH] USB storage: sg chaining support
> 
> Modify usb_stor_access_xfer_buf() to take a pointer to an sg
> entry pointer, so we can keep track of that instead of passing
> around an integer index (which we can't use when dealing with
> multiple scatterlist arrays).
> 
> Cc: greg@kroah.com
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

No objection from me, I'm guessing this needs to go through the scsi
tree?

thanks,

greg k-h
