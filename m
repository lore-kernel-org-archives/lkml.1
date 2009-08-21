Return-Path: <linux-kernel-owner+w=401wt.eu-S932303AbZHUPKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303AbZHUPKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 11:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932230AbZHUPKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 11:10:23 -0400
Received: from kroah.org ([198.145.64.141]:51206 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932217AbZHUPKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 11:10:22 -0400
Date: Fri, 21 Aug 2009 08:08:25 -0700
From: Greg KH <greg@kroah.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>
Subject: Re: [RFC] [PATCH v3 1/2] introduce ALS sysfs class
Message-ID: <20090821150825.GC10667@kroah.com>
References: <1250671229.17853.51.camel@rzhang-dt>
 <20090819160144.GB1020@kroah.com>
 <1250819647.17853.144.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250819647.17853.144.camel@rzhang-dt>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 21, 2009 at 09:54:07AM +0800, Zhang Rui wrote:
> ---
>  Documentation/ABI/testing/sysfs-class-als |   47 +++++
>  drivers/Kconfig                           |    2 
>  drivers/Makefile                          |    1 
>  drivers/als/Kconfig                       |   10 +
>  drivers/als/Makefile                      |    5 
>  drivers/als/als_sys.c                     |  256 ++++++++++++++++++++++++++++++
>  include/linux/als_sys.h                   |   57 ++++++

Does this file really need to be in include/linux/ ?

Or could you just put it into drivers/als/ and it would be fine?

thanks,

greg k-h
