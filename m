Return-Path: <linux-kernel-owner+w=401wt.eu-S1764379AbXKQBIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764379AbXKQBIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 20:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935476AbXKQBI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 20:08:27 -0500
Received: from mail.suse.de ([195.135.220.2]:48652 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935452AbXKQBI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 20:08:26 -0500
Date: Fri, 16 Nov 2007 17:06:08 -0800
From: Greg KH <gregkh@suse.de>
To: Timur Tabi <timur@freescale.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Add a private_data pointer to struct device_attribute
Message-ID: <20071117010608.GC13659@suse.de>
References: <11952582603203-git-send-email-timur@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11952582603203-git-send-email-timur@freescale.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 06:11:00PM -0600, Timur Tabi wrote:
> A private data pointer in struct device_attribute allows the 'show' and 'store'
> functions to access instance data.  This handy in situations where the
> driver_data and platform_data pointers of 'struct device' are already used
> for other purposes.
> 
> Signed-off-by: Timur Tabi <timur@freescale.com>
> ---
> 
> Greg, can you tell me if you think this patch is a good idea?  It doesn't
> appear to do any harm, and I'm working on an ALSA driver that could benefit
> for this patch.  I think 2.6.25 would be a good target.

Huh?  Why is this needed?  Can you give me a usage case for it?  Why
would you just not use the pointer to the attribute itself to identify
it?  All device specific information should be stored in the struct
device structure, as that is what describes the device, not the
attribute.

confused,

greg k-h
