Return-Path: <linux-kernel-owner+w=401wt.eu-S1751123AbZKZSKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751123AbZKZSKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 13:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbZKZSKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 13:10:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47371 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbZKZSKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 13:10:38 -0500
Date: Thu, 26 Nov 2009 10:06:46 -0800
From: Greg KH <gregkh@suse.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Jean Delvare <khali@linux-fr.org>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       List Linux Kernel <linux-kernel@vger.kernel.org>, rui.zhang@intel.com,
       alan@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/2] als: add unique device-ids to the als device class
Message-ID: <20091126180646.GA9059@suse.de>
References: <1259237081-4403-1-git-send-email-amit.kucheria@verdurent.com> <1259237186-5459-1-git-send-email-amit.kucheria@verdurent.com> <20091126160713.5e19eb04@hyperion.delvare> <4B0EB891.4010309@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0EB891.4010309@cam.ac.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 05:19:13PM +0000, Jonathan Cameron wrote:
> > That being said... If we want user-space to know what device is there,
> > we may want to still let drivers pass a name string to
> > als_device_register() and let the ALS core create a "name" sysfs
> > attribute returning the string in question. This would be much lighter
> > (for individual drivers) than the previous situation, as the string in
> > question would be a constant (e.g. "TSL2550".) Opinions?
> > 
> Makes sense given we want all drivers to support some form of identification.
> We could do it by stating they will all have that attribute, but given it's constant
> will save repetition to put it in the driver. Conversely it might complicate the handling
> of subsequent attribute_groups so I'd probably favour adding relevant documentation lines
> and leaving it up to the drivers to implement this attribute.
> 
> Thus we'd require (within reason) all drivers to have illuminance0 and name.

Why have a name attribute when you can just use the name of the device
itself instead?  Isn't that what it is there for?

confused,

greg k-h
