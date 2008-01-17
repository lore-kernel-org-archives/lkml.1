Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbYAQV42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbYAQV42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:56:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYAQV4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:56:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56779 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbYAQV4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:56:20 -0500
Date: Thu, 17 Jan 2008 14:00:07 -0800
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, raisch@de.ibm.com, jgarzik@pobox.com,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: 2.6.24-rc8-mm1 powerpc build errors
Message-ID: <20080117220007.GB12952@kroah.com>
References: <20080117023514.9df393cf.akpm@linux-foundation.org> <20080117190639.GA9499@lixom.net> <20080117113523.d802f991.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117113523.d802f991.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 11:35:23AM -0800, Andrew Morton wrote:
> On Thu, 17 Jan 2008 13:06:39 -0600 Olof Johansson <olof@lixom.net> wrote:
> > powerpc_allyesconfig:
> > 
> > drivers/net/ehea/ehea_main.c: In function 'ehea_driver_sysfs_add':
> > drivers/net/ehea/ehea_main.c:2812: error: 'struct device_driver' has no member named 'kobj'
> > drivers/net/ehea/ehea_main.c:2815: error: 'struct device_driver' has no member named 'kobj'
> > drivers/net/ehea/ehea_main.c:2818: error: 'struct device_driver' has no member named 'kobj'
> > drivers/net/ehea/ehea_main.c: In function 'ehea_driver_sysfs_remove':
> > drivers/net/ehea/ehea_main.c:2830: error: 'struct device_driver' has no member named 'kobj'
> 
> Looks like the driver tree wrecking ball failed to visit that driver.

Crap, I thought I fixed that one, but the patch never made it out...
I'll fix that tomorrow, sorry about that.

greg k-h
