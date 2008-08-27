Return-Path: <linux-kernel-owner+w=401wt.eu-S1759111AbYH0QYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111AbYH0QYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 12:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756313AbYH0QYC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 12:24:02 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33065 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710AbYH0QX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 12:23:59 -0400
Date: Wed, 27 Aug 2008 09:11:56 -0700
From: Greg KH <greg@kroah.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb@vger.kernel.org, Stefan Kopp <stefan_kopp@agilent.com>,
       Marcel Janssen <korgull@home.nl>, Felipe Balbi <me@felipebalbi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: add USB test and measurement class driver
Message-ID: <20080827161155.GD19710@kroah.com>
References: <20080827000501.GA29570@kroah.com> <200808271056.37159.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808271056.37159.oliver@neukum.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 10:56:36AM +0200, Oliver Neukum wrote:
> 5.get_capabilities
> kmalloced buffer is never freed

Now fixed.

> 6. disconnect fails to remove sysfs attributes

Ick, good catch, now fixed.

> 7. probe will report success even if usb_register_dev fails

now fixed.

thanks a lot for the review.

greg k-h
