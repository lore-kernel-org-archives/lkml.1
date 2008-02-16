Return-Path: <linux-kernel-owner+w=401wt.eu-S1761387AbYBPASk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761387AbYBPASk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 19:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756828AbYBPASe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 19:18:34 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51864 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbYBPASd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 19:18:33 -0500
Date: Fri, 15 Feb 2008 16:05:12 -0800
From: Greg KH <greg@kroah.com>
To: Jonas Bonn <jonas@southpole.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: pci_device_id definition cleanups
Message-ID: <20080216000512.GA18925@kroah.com>
References: <1203117700.16761.9.camel@satguru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203117700.16761.9.camel@satguru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 12:21:40AM +0100, Jonas Bonn wrote:
> I've done some work on cleaning up the definitions of pci_device_id to
> make them "static const" (where possible) and to make sure they go into
> __devinitconst.  There are about 350 changes of the type shown in the
> diff at the end of this mail.
> 
> ???All these changes are in my public GIT tree at:
> 
> git://www.southpole.se/~jonas/git/linux.git
> 
> (Based on 2.6.25-rc2)
> 
> In addition to these pci_device_id changes, there are a few changesets
> that move "const" data from __devinitdata to __devinitconst.
> 
> The tree above builds with both allmodconfig and allyesconfig.

Hm, does this save us any memory on any type of configuration?

What about drivers that end up writing to these structures (I know some
USB drivers do, not sure about PCI ones.)

You're going to need to send out patches for these to the different
developers, a git tree isn't going to help much.

thanks,

greg k-h
