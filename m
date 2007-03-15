Return-Path: <linux-kernel-owner+w=401wt.eu-S933410AbXCOHh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410AbXCOHh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 03:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933413AbXCOHh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 03:37:58 -0400
Received: from s-utl01-sjpop.stsn.net ([72.254.0.201]:63516 "HELO
	s-utl01-sjpop.stsn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933410AbXCOHh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 03:37:58 -0400
Date: Thu, 15 Mar 2007 00:25:03 -0700
From: Greg KH <greg@kroah.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove "decl_subsys_name" macro and single usage of it.
Message-ID: <20070315072503.GB8016@kroah.com>
References: <Pine.LNX.4.64.0703011205510.20928@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703011205510.20928@CPE00045a9c397f-CM001225dbafb6>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 12:09:59PM -0500, Robert P. J. Day wrote:
> 
>   Remove the macro "decl_subsys_name" which can be used to declare a
> sysfs subsystem, along with the single invocation of it in the source
> tree, since there appears to be little value in creating a subsystem
> whose subsystem name differs from its structure name.  Everyone else
> just uses "decl_subsys".
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
> @@ -800,7 +800,7 @@ MODULE_LICENSE("GPL");
>  module_param(debug, bool, 0644);
>  MODULE_PARM_DESC(debug, "Debugging mode enabled or not");
> 
> -EXPORT_SYMBOL_GPL(pci_hotplug_slots_subsys);
> +EXPORT_SYMBOL_GPL(slots_subsys);

No, don't polute the namespace incorrectly here.  We really want the
variable to still have the "pci_hotplug_" prefix if at all possible.

thanks,

greg k-h

