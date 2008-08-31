Return-Path: <linux-kernel-owner+w=401wt.eu-S1756693AbYHaFVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbYHaFVq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 01:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbYHaFVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 01:21:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57640 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbYHaFVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 01:21:36 -0400
Date: Sat, 30 Aug 2008 22:16:02 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Frans Pop <elendil@planet.nl>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [regression] usb: sometimes dead keyboard after boot
Message-ID: <20080831051602.GA17745@kroah.com>
References: <200808301640.21043.elendil@planet.nl> <Pine.LNX.4.44L0.0808302202250.514-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0808302202250.514-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 10:21:20PM -0400, Alan Stern wrote:
> (Actually even this might not be true any more.  There are patches in 
> development which make certain parts of the kernel initialization, 
> including driver probing, run in parallel threads rather than 
> serially.)

No, that did go in for one kernel release and then ripped out, it turned
out to not save any time and just cause lots more problems.  So don't
worry about this.

thanks,

greg k-h
