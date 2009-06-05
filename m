Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbZFERqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbZFERqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 13:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbZFERqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 13:46:35 -0400
Received: from kroah.org ([198.145.64.141]:48696 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237AbZFERqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 13:46:34 -0400
Date: Fri, 5 Jun 2009 10:42:19 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: linux-next: manual merge of the usb tree with the ttydev tree
Message-ID: <20090605174219.GE6479@kroah.com>
References: <20090605154118.9e9521f3.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090605154118.9e9521f3.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 03:41:18PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/serial/kobil_sct.c between commit
> d6ba273795c1260745197dc93f64c321c80a5ecc ("tty-usb-use-port") from the
> ttydev tree and commit 8a5870836006ec7dd112082a39e0057b49e5bd91 ("USB:
> usb-serial: replace shutdown with disconnect, release") from the usb tree.
> 
> The latter removed the code (from kobil_shutdown) that the former
> modified, so I just used the latter.

That sounds correct.

thanks,

greg k-h
