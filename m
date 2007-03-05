Return-Path: <linux-kernel-owner+w=401wt.eu-S1752609AbXCEDv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbXCEDv1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 22:51:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbXCEDv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 22:51:27 -0500
Received: from mail.kroah.org ([69.55.234.183]:39125 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbXCEDv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 22:51:26 -0500
Date: Sun, 4 Mar 2007 19:35:33 -0800
From: Greg KH <greg@kroah.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Pavel Machek <pavel@ucw.cz>,
       Marcel Holtmann <marcel@holtmann.org>, linux-pm@lists.osdl.org,
       maxk@qualcomm.com, bluez-devel@lists.sourceforge.net,
       Mark Lord <lkml@rtr.ca>, Matt Mackall <mpm@selenic.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Albert Hopkins <kernel@marduk.letterboxes.org>,
       Ayaz Abdulla <aabdulla@nvidia.com>, Jeff Garzik <jeff@garzik.org>,
       netdev@vger.kernel.org
Subject: Re: [1/6] 2.6.21-rc2: known regressions
Message-ID: <20070305033533.GA28319@kroah.com>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015031.GF3441@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305015031.GF3441@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 02:50:31AM +0100, Adrian Bunk wrote:
> Subject    : kref refcounting breakage
> References : http://lkml.org/lkml/2007/3/2/67
> Submitter  : Andrew Morton <akpm@linux-foundation.org>
> Handled-By : Greg KH <greg@kroah.com>
> Status     : unknown

I'm working on tracking this down still...

> Subject    : wireless breakage (ipw2200, iwconfig, NetworkManager)
> References : http://lkml.org/lkml/2007/3/4/135
> Submitter  : Matt Mackall <mpm@selenic.com>
> Caused-By  : Greg Kroah-Hartman <gregkh@suse.de> (?)
>              commit 43cb76d91ee85f579a69d42bc8efc08bac560278 (?)
> Handled-By : Johannes Berg <johannes@sipsolutions.net>
> Status     : unknown

I really think this is a CONFIG_SYSFS_DEPRECATED issue (not being set),
but want to get Matt confirm either way before saying this is a real
issue or not.

thanks,

greg k-h
