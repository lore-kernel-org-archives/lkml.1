Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbYI2XRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbYI2XRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 19:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbYI2XRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 19:17:10 -0400
Received: from kroah.org ([198.145.64.141]:34982 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751477AbYI2XRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 19:17:08 -0400
Date: Mon, 29 Sep 2008 16:11:02 -0700
From: Greg KH <greg@kroah.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CONFIG_SECURITY_ROOTPLUG [was: Re: 2.6.27-rc7 no init found on
	the root partition?]
Message-ID: <20080929231102.GA4665@kroah.com>
References: <20080925165400.GQ31582@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925165400.GQ31582@ics.muni.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 06:54:00PM +0200, Lukas Hejtmanek wrote:
> Hello,
> 
> I finally found my problems with no init found.
> 
> It was caused by the CONFIG_SECURITY_ROOTPLUG option.
> 
> I wonder why this option in 2.6.26.3 kernel allows the kernel boot up, while
> with 2.6.27-rc7, the kernel is unable to run even init.

If you enable that option, you have to have the specific USB device
plugged into your system in order for any process to run as root (like
init).

So, odds are you don't have this specific device, so either specify a
different device id, or don't build it into your kernel :)

thanks,

greg k-h
