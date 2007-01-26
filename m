Return-Path: <linux-kernel-owner+w=401wt.eu-S1161234AbXAZUml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161234AbXAZUml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 15:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161249AbXAZUmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 15:42:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55304 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161234AbXAZUmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 15:42:40 -0500
Date: Fri, 26 Jan 2007 12:41:40 -0800
From: Greg KH <gregkh@suse.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix /sys/device/.../power/state regression
Message-ID: <20070126204140.GA8407@suse.de>
References: <20061219185223.GA13256@srcf.ucam.org> <200612201318.06976.david-b@pacbell.net> <20061221012924.GC32625@srcf.ucam.org> <200612201904.28681.david-b@pacbell.net> <20061221040648.GA1499@srcf.ucam.org> <20070125050009.GA8672@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070125050009.GA8672@srcf.ucam.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 25, 2007 at 05:00:09AM +0000, Matthew Garrett wrote:
> In 2.6.19, support for splitting driver suspend and resume callbacks 
> into interrupt and non-interrupt contexts was added. Unfortunately, this 
> broke /sys/device/.../power/state support for all devices. In the long 
> run, this should be obsoleted by power management support in the 
> individual drivers - however, in the case of network drivers (for 
> example), currently only three drivers implement any sort of useful 
> run-time power management.
> 
> This patch allows the bus driver to check whether a specific driver 
> requires the split. If not, the 2.6.18 functionality is restored. It 
> also alters feature-removals.txt to note that the deprecated 
> functionality should not be removed until a replacement actually exists.

Ick, no.

As stated before, it was broken in the past, and no userspace tools use
it because of that.  So it was disabled.

Or am I misstating that long thread?  David, your thoughts?

thanks,

greg k-h
