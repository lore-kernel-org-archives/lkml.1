Return-Path: <linux-kernel-owner+w=401wt.eu-S1757069AbYLDBId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069AbYLDBId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 20:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757726AbYLDBHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 20:07:47 -0500
Received: from mail.vyatta.com ([76.74.103.46]:42464 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496AbYLDBHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 20:07:46 -0500
X-Spam-Flag: NO
X-Spam-Score: -1.388
Date: Wed, 3 Dec 2008 17:07:41 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: [PATCH 1/4] dmaengine: add a release for dma class devices and
 dependent infrastructure
Message-ID: <20081203170741.7f25d756@extreme>
In-Reply-To: <20081204004646.27790.70015.stgit@dwillia2-linux.ch.intel.com>
References: <20081204004514.27790.51174.stgit@dwillia2-linux.ch.intel.com>
	<20081204004646.27790.70015.stgit@dwillia2-linux.ch.intel.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Dec 2008 17:46:46 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Resolves:
> WARNING: at drivers/base/core.c:122 device_release+0x4d/0x52()
> Device 'dma0chan0' does not have a release() function, it is broken and must be fixed.
> 
> The dma_chan_dev object is introduced to gear-match sysfs kobject and
> dmaengine channel lifetimes.  When a channel is removed access to the
> sysfs entries return -ENODEV until the kobject can be released.
> 
> The bulk of the change is updates to existing code to handle the extra
> layer of indirection between a dma_chan and its struct device.
> 
> Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
> Cc: Stephen Hemminger <shemminger@vyatta.com>
> Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Much better thanks.
