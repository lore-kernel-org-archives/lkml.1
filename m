Return-Path: <linux-kernel-owner+w=401wt.eu-S1758625AbYBSR5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbYBSR5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 12:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbYBSR5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 12:57:03 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44544 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972AbYBSR5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 12:57:01 -0500
Date: Tue, 19 Feb 2008 09:54:23 -0800
From: Greg KH <greg@kroah.com>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] try parent numa_node at first before using default
	v2
Message-ID: <20080219175423.GC8344@kroah.com>
References: <200802190311.44404.yinghai.lu@sun.com> <200802190320.41210.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802190320.41210.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 03:20:41AM -0800, Yinghai Lu wrote:
> 
> in the device_add, we try to use use parent numa_node.
> need to make sure pci root bus's bridge device numa_node is set.
> then we could use device->numa_node direclty for all device.
> and don't need to call pcibus_to_node().
> 
> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

This should be split into different patches, one for the driver core,
and one for the PCI stuff as they are doing totally different things
here.

thanks,

greg k-h
