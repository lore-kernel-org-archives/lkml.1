Return-Path: <linux-kernel-owner+w=401wt.eu-S1030850AbXAZUnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030850AbXAZUnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 15:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030851AbXAZUnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 15:43:22 -0500
Received: from mx1.suse.de ([195.135.220.2]:45101 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030834AbXAZUnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 15:43:21 -0500
Date: Fri, 26 Jan 2007 12:42:26 -0800
From: Greg KH <gregkh@suse.de>
To: Andrew Morton <akpm@osdl.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix /sys/device/.../power/state regression
Message-ID: <20070126204226.GB8407@suse.de>
References: <20061219185223.GA13256@srcf.ucam.org> <200612201318.06976.david-b@pacbell.net> <20061221012924.GC32625@srcf.ucam.org> <200612201904.28681.david-b@pacbell.net> <20061221040648.GA1499@srcf.ucam.org> <20070125050009.GA8672@srcf.ucam.org> <20070126115905.66940ac9.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070126115905.66940ac9.akpm@osdl.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 26, 2007 at 11:59:05AM -0800, Andrew Morton wrote:
> On Thu, 25 Jan 2007 05:00:09 +0000
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> 
> > In 2.6.19, support for splitting driver suspend and resume callbacks 
> > into interrupt and non-interrupt contexts was added. Unfortunately, this 
> > broke /sys/device/.../power/state support for all devices. In the long 
> > run, this should be obsoleted by power management support in the 
> > individual drivers - however, in the case of network drivers (for 
> > example), currently only three drivers implement any sort of useful 
> > run-time power management.
> > 
> > This patch allows the bus driver to check whether a specific driver 
> > requires the split. If not, the 2.6.18 functionality is restored. It 
> > also alters feature-removals.txt to note that the deprecated 
> > functionality should not be removed until a replacement actually exists.
> 
> That sounds like material for 2.6.20 as well as for 2.6.19.x.

No, it's not stable material, as drivers would have to be modified to
support it, and that is adding new stuff.  See my other comment about
why this was changed because it was broken...

thanks,

greg k-h
