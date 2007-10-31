Return-Path: <linux-kernel-owner+w=401wt.eu-S1759155AbXJaL2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759155AbXJaL2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 07:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755922AbXJaL1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 07:27:54 -0400
Received: from twin.jikos.cz ([213.151.79.26]:40177 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755161AbXJaL1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 07:27:54 -0400
Date: Wed, 31 Oct 2007 12:27:24 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-input@atrey.karlin.mff.cuni.cz,
       linux-usb-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hiddev: compat_ptr() returns a void *
In-Reply-To: <20071031145153.30f9d3dd.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0710311217370.18815@twin.jikos.cz>
References: <20071031145153.30f9d3dd.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2007, Stephen Rothwell wrote:

> so cast it to unsigned long before passing it to hiddev_ioctl.
> This gets rid of:
> drivers/hid/usbhid/hiddev.c: In function 'hiddev_compat_ioctl':
> drivers/hid/usbhid/hiddev.c:746: warning: passing argument 4 of 'hiddev_ioctl' makes integer from pointer without a cast
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Hi Stephen,

I already have this fixed in my tree, sorry.

Thanks a lot,

-- 
Jiri Kosina
