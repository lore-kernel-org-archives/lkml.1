Return-Path: <linux-kernel-owner+w=401wt.eu-S1759094AbXIIUET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759094AbXIIUET (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 16:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbXIIUEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 16:04:09 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34431 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbXIIUEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 16:04:05 -0400
Date: Sun, 9 Sep 2007 09:26:58 -0700
From: Greg KH <greg@kroah.com>
To: Eric Lammerts <eric@lammerts.org>
Cc: linux-kernel@vger.kernel.org, p.hardwick@option.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] nozomi DTR/RTS
Message-ID: <20070909162658.GA23411@kroah.com>
References: <46CEACC0.5000908@lammerts.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CEACC0.5000908@lammerts.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 12:02:40PM +0200, Eric Lammerts wrote:
> Hi,
> I noticed that DTR toggling doesn't work with the nozomi driver 
> (TIOCMBIS/TIOCMBIC ioctls have no effect). This is a nuisance because that 
> makes it hard to get the modem back in command mode.
>
> Attached patch adds a tty_ops->tiocmset function that makes it work.
>
> Should we also rip out the TIOCMBIS/TIOCMBIC handling in ntty_ioctl()? It 
> doesn't seem to be used anyway.
>
> Patch is against 2.6.23-rc3-mm1, but not tested with that. I tested it with 
> 2.6.18.4 and the pharscape.org driver.

Thanks, I've updated the driver in -mm with these changes.

greg k-h
