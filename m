Return-Path: <linux-kernel-owner+w=401wt.eu-S1756506AbZHFS6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbZHFS6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 14:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755715AbZHFS6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 14:58:44 -0400
Received: from kroah.org ([198.145.64.141]:36165 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755680AbZHFS5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 14:57:51 -0400
Date: Thu, 6 Aug 2009 11:52:35 -0700
From: Greg KH <greg@kroah.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Richard Purdie <rpurdie@rpsys.net>,
       Matthew Wilcox <matthew@wil.cx>, Len Brown <lenb@kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Subject: Re: [RFC PATCH V2 2/2] introduce ACPI ALS device driver
Message-ID: <20090806185235.GA28664@kroah.com>
References: <1249547500.2670.500.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249547500.2670.500.camel@rzhang-dt>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 04:31:40PM +0800, Zhang Rui wrote:
> 
> ACPI spec defines ACPI Ambient Light Sensor device (hid ACPI0008),
> which provides a standard interface by which the OS may query properties
> of the ambient light environment the system is currently operating in,
> as well as the ability to detect meaningful changes in these values when the
> environment changes.

If you are adding new sysfs files, they need to be documented in
Documentation/ABI at the same time.  Please do that for these.

thanks,

greg k-h
