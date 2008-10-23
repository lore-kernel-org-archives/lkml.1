Return-Path: <linux-kernel-owner+w=401wt.eu-S1752709AbYJWFLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbYJWFLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 01:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbYJWFLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 01:11:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:50849 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187AbYJWFLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 01:11:05 -0400
Date: Wed, 22 Oct 2008 21:55:05 -0700
From: Greg KH <gregkh@suse.de>
To: Len Brown <lenb@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Hiroshi Miura <miura@da-cha.org>,
       YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
       Harald Welte <laforge@gnumonks.org>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 01/42] Staging: add pcc-acpi driver
Message-ID: <20081023045505.GA7539@suse.de>
References: <20081022172203.GA4000@kroah.com> <1224696563-5170-1-git-send-email-gregkh@suse.de> <alpine.LFD.1.10.0810221434070.3010@localhost.localdomain> <20081022184808.GA24150@suse.de> <alpine.LFD.1.10.0810222244130.3010@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0810222244130.3010@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 10:49:26PM -0400, Len Brown wrote:
> 
> 
> On Wed, 22 Oct 2008, Greg KH wrote:
> 
> > On Wed, Oct 22, 2008 at 02:37:18PM -0400, Len Brown wrote:
> > > NAK.
> > > this was already relplaced by the panasonic driver in the acpi tree.
> > 
> > Is this in 2.6.27, or was it a 2.6.28 addition?  For some reason, I had
> > reports from openSUSE users that 2.6.27 still didn't work properly and
> > needed this driver.
> > 
> > How about the new "pcc-acpi-cdrom" driver hack?  Hiroshi, is that needed
> > still with the 2.6.27 kernel?
> 
> drivers/misc/panasonic-laptop.c is staged for 2.6.28:
> 
> http://git.kernel.org/?p=linux/kernel/git/lenb/linux-acpi-2.6.git;a=history;f=drivers/misc/panasonic-laptop.c;h=a2cb598d8ab54a98000d1f31f7c2407924399a5e;hb=test

Hm, we didn't get the acpi merge with Linus yet for .28?  No wonder I
missed this, sorry about it.

> > > Greg,
> > > If it has the word "acpi" in it, please check with me before
> > > putting something in the staging tree, for I'd prefer to
> > > stage such things in the acpi tree.
> > 
> > Ok, I didn't know you wanted "uncleaned" drivers in your tree, I'll
> > remember this for the future :)
> 
> AFAICK, the driver that was checked into staging tree
> was based on an older version of the driver already staged
> in the acpi tree.  I think that the staging tree
> isn't helping us in this scenario.

Fair enough, I'll drop it from my tree, thanks for paying attention and
letting me know.

greg k-h
