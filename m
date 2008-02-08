Return-Path: <linux-kernel-owner+w=401wt.eu-S1763477AbYBHWqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763477AbYBHWqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:46:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764550AbYBHWld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:41:33 -0500
Received: from bgo1smout1.broadpark.no ([217.13.4.94]:36582 "EHLO
	bgo1smout1.broadpark.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764536AbYBHWlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:41:31 -0500
X-Greylist: delayed 3641 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Feb 2008 17:41:30 EST
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=US-ASCII
Date: Fri, 08 Feb 2008 18:04:20 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Ben Nizette <bn@niasdigital.com>
Cc: kernel@avr32linux.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] AVR32: pass i2c board info through at32_add_device_twi
Message-id: <20080208180420.095cfb91@dhcp-252-066.norway.atmel.com>
In-reply-to: <47AA8909.3040706@niasdigital.com>
References: <47AA8909.3040706@niasdigital.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Feb 2008 15:28:57 +1100
Ben Nizette <bn@niasdigital.com> wrote:

> New-style I2C drivers require that motherboard-mounted I2C devices are
> registered with the I2C core, typically at arch_initcall time.  This can be
> done nice and neat by passing the struct i2c_board_info[] through
> at32_add_device_twi just like we do for the SPI board info.
> 
> While we've got the hood up, remove a duplicate declaration of
> at32_add_device_twi() in board.h.
> 
> Signed-Off-By: Ben Nizette <bn@niasdigital.com>

Applied, thanks.

Haavard
