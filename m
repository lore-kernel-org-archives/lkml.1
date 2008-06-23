Return-Path: <linux-kernel-owner+w=401wt.eu-S1755049AbYFWLUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbYFWLUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 07:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbYFWLUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 07:20:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42949 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbYFWLUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 07:20:06 -0400
Date: Mon, 23 Jun 2008 07:20:04 -0400
From: Christoph Hellwig <hch@infradead.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Deti Fliegl <deti@fliegl.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, jaswinder@infradead.org
Subject: Re: [PATCH] dabusb: use request_firmware()
Message-ID: <20080623112004.GA26516@infradead.org>
References: <1214219201.27974.21.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214219201.27974.21.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +config USB_DABUSB_FIRMWARE
> +	bool "Include firmware images for DABUSB driver"
> +	depends on USB_DABUSB
> +	---help---
> +	Include the firmware for the DABUSB device in the kernel image.
> +	Say 'N' and let it get loaded from userspace.

Sorry if I missed a discussion on it in the intial firmware threads, but
what is the point of all these FOO_FIRMWARE options?  I think we should
include all firmware that we have a driver for if people want firmware
built-in and non if not.

That is instead of all these FOO_FIRMWARE options just have one
user-visible BUILTIN_FIRMWARE option.  Also makes it much less likely
for mingo to accidentally build a kernel image that doesn't actually boot :)

