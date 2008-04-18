Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601AbYDRDBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbYDRDBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 23:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbYDRDBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 23:01:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43770 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbYDRDBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 23:01:07 -0400
Date: Thu, 17 Apr 2008 20:00:55 -0700
From: Greg KH <greg@kroah.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH mm] sysfs: add /sys/dev/usb to handle
	CONFIG_USB_DEVICE_CLASS=y
Message-ID: <20080418030055.GA3429@kroah.com>
References: <1208484663.12570.5.camel@dwillia2-linux.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208484663.12570.5.camel@dwillia2-linux.ch.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 07:11:03PM -0700, Dan Williams wrote:
> The deprecated config option CONFIG_USB_DEVICE_CLASS causes class devices
> with duplicate major:minor numbers to be registered.  In effect they
> represent a usb specific address space for major:minor numbers so add 'usb'
> as a directory along side 'block' and 'char'.
> 
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> This boots up without warning on my dev system.  We end up with the
> following situation:

This patch is not going to work if usbcore is a module :(

thanks,

greg k-h
