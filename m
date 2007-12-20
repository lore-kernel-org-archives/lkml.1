Return-Path: <linux-kernel-owner+w=401wt.eu-S936650AbXLTRZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936650AbXLTRZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 12:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932433AbXLTRZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 12:25:11 -0500
Received: from ns.suse.de ([195.135.220.2]:52950 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932619AbXLTRZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 12:25:09 -0500
Date: Thu, 20 Dec 2007 09:19:14 -0800
From: Greg KH <gregkh@suse.de>
To: Tony Camuso <tcamuso@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 4/5]PCI: x86 MMCONFIG: introduce
	pcibios_fix_bus_scan()]
Message-ID: <20071220171914.GA5636@suse.de>
References: <476A5F69.2030501@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476A5F69.2030501@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 07:26:17AM -0500, Tony Camuso wrote:
>>> +
>>> +#define CHECK_MMCFG_STR_1 \
>>> +	"PCI: Device at %04x:%02x.%02x.%x is not MMCONFIG compliant.\n"
>>> +#define CHECK_MMCFG_STR_2 \
>>> +	"PCI: Bus %04x:%02x and its descendents cannot use MMCONFIG.\n"
>> Why define these if they are only used in one place?
>
> If you object, I will be happy to move them into the routine body
> without the defines. I agree that It does look inconsistent to have
> these strings defined and other strings embedded in the routine body.

Yes, please fix this.

>> Also, as you use dev_info(), I think you are duplicating some of the
>> information in the resulting printk(), right?
> Actually, no. The strings do not contain redundant info. The pr_info
> routine is just a macro for printk(KERN_INFO ...)

Ah, sorry, I was thinking you were using dev_info(), which is what you
should be using instead anyway :)

thanks,

greg k-h
