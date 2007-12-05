Return-Path: <linux-kernel-owner+w=401wt.eu-S1753398AbXLEQXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbXLEQXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 11:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbXLEQXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 11:23:16 -0500
Received: from ns.suse.de ([195.135.220.2]:42948 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbXLEQXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 11:23:15 -0500
Date: Wed, 5 Dec 2007 08:21:52 -0800
From: Greg KH <gregkh@suse.de>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 0/3] driver core: Fix s390, get default driver
	attributes for free.
Message-ID: <20071205162152.GA9631@suse.de>
References: <20071205125001.5b64442d@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071205125001.5b64442d@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 12:50:01PM +0100, Cornelia Huck wrote:
> Hi Greg,
> 
> I spent some time fixing up the driver tree on s390 and found that the
> easiest way to do so is to introduce default attribute groups for
> device drivers (like for devices).
> 
> Since I'm lazy, I didn't take care to delay the uevent for device
> drivers to after adding the attribute groups, but this should be done
> when struct device_driver is converted to the new kobject interface.

Wonderful, thanks for doing this, looks nice.

greg k-h
