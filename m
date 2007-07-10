Return-Path: <linux-kernel-owner+w=401wt.eu-S1761406AbXGJAZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761406AbXGJAZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 20:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760607AbXGJAZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 20:25:18 -0400
Received: from canuck.infradead.org ([209.217.80.40]:35507 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759460AbXGJAZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 20:25:14 -0400
Date: Mon, 9 Jul 2007 17:09:25 -0700
From: Greg KH <greg@kroah.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] backlight: Convert from struct class_device to struct
	device
Message-ID: <20070710000925.GB4954@kroah.com>
References: <1183981204.5757.32.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183981204.5757.32.camel@localhost.localdomain>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2007 at 12:40:04PM +0100, Richard Purdie wrote:
> Convert the backlight and LCD classes from struct class_device to struct
> device since class_device is scheduled for removal.
> 
> One nasty API break is the backlight power attribute has had to be
> renamed to bl_power and the LCD power attribute has had to be renamed to
> lcd_power since the original names clash with the core. I can't see a
> way around this.
> 
> Signed-off-by: Richard Purdie <rpurdie@rpsys.net>
> 
> [I've applied this patch to the backlight for-mm branch for testing but
> will work in any feedback] 

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

