Return-Path: <linux-kernel-owner+w=401wt.eu-S1752470AbYJ0QQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbYJ0QQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYJ0QQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:16:31 -0400
Received: from kroah.org ([198.145.64.141]:41192 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750795AbYJ0QQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:16:31 -0400
Date: Mon, 27 Oct 2008 09:14:06 -0700
From: Greg KH <greg@kroah.com>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Add c2 port support.
Message-ID: <20081027161406.GA14500@kroah.com>
References: <20081022174004.GB10587@kroah.com> <20081022111145.e5f3c632.akpm@linux-foundation.org> <20081022195245.GS4390@tekkaman> <20081022130150.00836eba.akpm@linux-foundation.org> <20081022204800.GT4390@tekkaman> <20081022135810.37c564f8.akpm@linux-foundation.org> <20081022210352.GA29754@kroah.com> <20081023073957.GU4390@tekkaman> <20081023153733.GA4011@kroah.com> <20081027085414.GH11339@tekkaman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027085414.GH11339@tekkaman>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 09:54:14AM +0100, Rodolfo Giometti wrote:
> On Thu, Oct 23, 2008 at 08:37:33AM -0700, Greg KH wrote:
> 
> > And again, you can still use sysfs for that as well.  I was just
> > referring to the binary sysfs file that you use for the firmware
> > download, it would make more sense for you to use the standard kernel
> > firmware download interface instead of rolling your own here.
> 
> If I well understand the firmware class it works starting the firmware
> download from the kernel side, that is into the kernel we should call
> request_firmware() and then the files will
> /sys/class/firmware/xxx/{loading,data} appear.

Yes, that is true, but userspace doesn't have to write to those files
until it feels like it.

> This solution doesn't fit C2 port needs since the firmware download is
> decided from userland erasing and then writing into the
> microcontroller on-board flash.

That's fine, you can still use the same interface, no problems.  Just
use the "async" version of the firmware interfae and you will be fine.

thanks,

greg k-h
