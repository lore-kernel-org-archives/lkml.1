Return-Path: <linux-kernel-owner+w=401wt.eu-S936140AbXHNWyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936140AbXHNWyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935837AbXHNWxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 18:53:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47518 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935751AbXHNWxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 18:53:43 -0400
Date: Tue, 14 Aug 2007 15:35:12 -0700
From: Greg KH <greg@kroah.com>
To: tonyj@suse.de
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [patch 1/6] Convert from class_device to device in
	drivers/char/drm
Message-ID: <20070814223512.GA6375@kroah.com>
References: <20070808052842.451400000@suse.de> <20070808053013.880837000@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070808053013.880837000@suse.de>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 10:28:43PM -0700, tonyj@suse.de wrote:
> Convert from class_device to device in drivers/char/drm.
> 
> Signed-off-by: Tony Jones <tonyj@suse.de>
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> 
> ---
>  drivers/char/drm/drmP.h      |    8 ++---
>  drivers/char/drm/drm_stub.c  |    9 +++---
>  drivers/char/drm/drm_sysfs.c |   58 ++++++++++++++++++++++---------------------
>  3 files changed, 39 insertions(+), 36 deletions(-)

This should go to the drm maintainer, not me.  But they look good, feel
free to add my:
	Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

to it.

thanks,

greg k-h
