Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab0BINIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 08:08:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37542 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab0BINIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 08:08:21 -0500
Date: Tue, 9 Feb 2010 05:08:04 -0800
From: Greg KH <gregkh@suse.de>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: sarah.a.sharp@linux.intel.com, linux-usb@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: don't read past config->interface[] if
 usb_control_msg() fails in usb_reset_configuration()
Message-ID: <20100209130804.GB30014@suse.de>
References: <4B715C55.5090102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B715C55.5090102@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 09, 2010 at 02:00:05PM +0100, Roel Kluin wrote:
> After the loop `for (i = 0; i < config->desc.bNumInterfaces; i++)' if no
> break occurred, i equals config->desc.bNumInterfaces. so if
> usb_control_msg() failed then after goto reset_old_alts we read from
> config->interface[config->desc.bNumInterfaces].
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Have you seen this happen on real hardware?

curious,

greg k-h
