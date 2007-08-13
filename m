Return-Path: <linux-kernel-owner+w=401wt.eu-S933872AbXHMVke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933872AbXHMVke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 17:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbXHMVkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 17:40:07 -0400
Received: from mail.suse.de ([195.135.220.2]:43340 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757176AbXHMVkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 17:40:04 -0400
Date: Mon, 13 Aug 2007 14:17:50 -0700
From: Greg KH <gregkh@suse.de>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [patch] encapsulate uevent()/add_uevent_var() buffer handling
Message-ID: <20070813211750.GA16120@suse.de>
References: <20070813143711.GA24536@s15225674.onlinehome-server.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070813143711.GA24536@s15225674.onlinehome-server.info>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 04:37:11PM +0200, Kay Sievers wrote:
> Hi,
> this changes the uevent buffer stuff to use a struct instead
> of tons of parameters. It does no longer require the caller to
> do the proper buffer termination and size accounting, which is
> currently wrong in a lot of places.
> 
> This tells everything:
>   47 files changed, 265 insertions(+), 605 deletions(-)
> 
> Thanks,
> Kay
> 
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: Driver core: encapsulate uevent()/add_uevent_var() buffer handling

Very nice, care to respin this with the one issue that Cornelia pointed
out?

thanks,

greg k-h
