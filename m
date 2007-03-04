Return-Path: <linux-kernel-owner+w=401wt.eu-S1751661AbXCDQ2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661AbXCDQ2S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 11:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbXCDQ2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 11:28:18 -0500
Received: from mail.kroah.org ([69.55.234.183]:37283 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbXCDQ2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 11:28:17 -0500
Date: Sun, 4 Mar 2007 08:27:09 -0800
From: Greg KH <greg@kroah.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KCONFIG:  Set the default for the deprecated sysfs entries to N.
Message-ID: <20070304162709.GB24613@kroah.com>
References: <Pine.LNX.4.64.0703040604330.16320@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703040604330.16320@CPE00045a9c397f-CM001225dbafb6>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 04, 2007 at 06:08:04AM -0500, Robert P. J. Day wrote:
> 
>   Set the default for creating deprecated sysfs files to "no".
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
> ---
> 
>   Given that the help info for this entry states that "None of these
> features or values should be used today," it makes more sense for the
> config entry to default to no, wouldn't you think?

No, it turns out that there were just too many people using older
userspaces, so the default of Y is correct for now.  It's also safer
that way as otherwise people build kernels that don't boot.

So sorry, I'm not going to apply this change.

thanks,

greg k-h
