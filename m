Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbZICSRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbZICSRs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 14:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756119AbZICSRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 14:17:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:41327 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755997AbZICSRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 14:17:45 -0400
Date: Thu, 3 Sep 2009 11:04:53 -0700
From: Greg KH <gregkh@suse.de>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix missing include file in RTL8192U staging driver
Message-ID: <20090903180453.GA25231@suse.de>
References: <20090903115213.GA4315@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090903115213.GA4315@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 05:22:13PM +0530, Kamalesh Babulal wrote:
> Hi Greg,
> 
> 	2.6.31-rc8 build fails with
> 
> drivers/staging/rtl8192su/r8192U_core.c:5086: error: implicit declaration of function 'vmalloc'
> drivers/staging/rtl8192su/r8192U_core.c:5086: warning: cast to pointer from integer of different size
> drivers/staging/rtl8192su/r8192U_core.c: In function 'rtl8192_usb_disconnect':
> drivers/staging/rtl8192su/r8192U_core.c:12308: error: implicit declaration of function 'vfree'
> 
> Including the vmalloc.h file, fixes the build failure. I have tested the
> patch for build failure only.

On what arch are you hitting this?

This should all be resolved in the linux-next tree, right?

thanks,

greg k-h
