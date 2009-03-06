Return-Path: <linux-kernel-owner+w=401wt.eu-S1756650AbZCFR66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbZCFR66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 12:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756543AbZCFR6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 12:58:34 -0500
Received: from kroah.org ([198.145.64.141]:34426 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756547AbZCFR6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 12:58:33 -0500
Date: Fri, 6 Mar 2009 09:57:34 -0800
From: Greg KH <greg@kroah.com>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org
Subject: Re: [PATCH] pci: expose boot VGA device via sysfs.
Message-ID: <20090306175734.GE3099@kroah.com>
References: <alpine.DEB.2.00.0903040555490.28485@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903040555490.28485@skynet.skynet.ie>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 04, 2009 at 05:57:05AM +0000, Dave Airlie wrote:
> 
> X really would like to know which VGA device was considered the boot
> device by the system. The x86 PCI fixups have support for discovering this
> but we provide no way to expose it to userspace.
> 
> This adds a sysfs file per VGA class device which has the value 0 for
> non the boot device or unknown, and 1 if the VGA device is the boot device.
> 
> Signed-off-by: Dave Airlie <airlied@redhat.com>

Looks good to me:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

thanks,

greg k-h
