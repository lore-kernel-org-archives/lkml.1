Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbYI2Pv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbYI2Pv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 11:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbYI2Pvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 11:51:50 -0400
Received: from [198.145.64.141] ([198.145.64.141]:48371 "EHLO coco.kroah.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751264AbYI2Pvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 11:51:50 -0400
Date: Mon, 29 Sep 2008 08:42:27 -0700
From: Greg KH <greg@kroah.com>
To: Alan Young <ayoung@teleport.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [kernel-abi] symbol versioning vs. out-of-tree modules.
Message-ID: <20080929154227.GA10741@kroah.com>
References: <31134782.1222671063829.JavaMail.root@elwamui-mouette.atl.sa.earthlink.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31134782.1222671063829.JavaMail.root@elwamui-mouette.atl.sa.earthlink.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2008 at 11:51:03PM -0700, Alan Young wrote:
> On Thu, 25 Sep 2008 at 05:10:07 +0200, Greg KH wrote:
> 
> > What kernel modules do you currently use/rely on that are not in the
> > main kernel tree?  Do you have links to them?  I'd be glad to add them.
> 
> I still use the ES56-PI modem driver @ http://tx.technion.ac.il/~raindel.
> It has a 2.6 port up to 2.6.24, but it's not more current than that due to
> serial/tty interface changes.  And there's a challenge that it uses a binary
> blob. :-(  Best case would be to see if the vendor could open up like
> Atheros (Thanks! Yea!) did.  If not, I wonder if the blob could be
> minimalized to the bare modem functions and the serial interfaces be
> brought out into open code.

If the blob is removed, then yes, we can include it into the kernel tree
and I will be glad to help get it there.  But until then, sorry, there's
not much we can do.

thanks,

greg k-h
