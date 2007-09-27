Return-Path: <linux-kernel-owner+w=401wt.eu-S1757978AbXI0RvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978AbXI0RvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 13:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754981AbXI0RvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 13:51:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42135 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbXI0RvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 13:51:05 -0400
Date: Thu, 27 Sep 2007 10:46:04 -0700
From: Greg KH <greg@kroah.com>
To: jblunck@suse.de
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@lst.de,
       agruen@suse.de, tiwai@suse.de
Subject: Re: [patch 02/10] Dont touch fs_struct in usermodehelper
Message-ID: <20070927174604.GA8339@kroah.com>
References: <20070927141200.820970144@X40.localnet> <20070927141227.559764756@X40.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927141227.559764756@X40.localnet>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 04:12:02PM +0200, jblunck@suse.de wrote:
> This test seems to be unnecessary since we always have rootfs mounted before
> calling a usermodehelper.

Are you sure this is true?  I thought we called the usermode helper for
hotplug _very_ early in the boot sequence when the device tree starts to
get populated.

But things could have changed from the 2.5 days when this was first
added, if so, nevermind me :)

thanks,

greg k-h
