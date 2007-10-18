Return-Path: <linux-kernel-owner+w=401wt.eu-S1764120AbXJRPZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764120AbXJRPZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 11:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755971AbXJRPZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 11:25:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:48695 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbXJRPZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 11:25:38 -0400
Date: Thu, 18 Oct 2007 08:24:53 -0700
From: Greg KH <gregkh@suse.de>
To: David Miller <davem@davemloft.net>
Cc: Shane.Huang@amd.com, htejun@gmail.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, Henry.Su@amd.com,
       Libin.Yang@amd.com
Subject: Re: [patch] PCI: disable MSI on more ATI NorthBridges
Message-ID: <20071018152453.GA12902@suse.de>
References: <20071018.031957.104033396.davem@davemloft.net> <5CAB7B5D6F8AB84AA868A46B47A507055D8C67@sshaexmb1.amd.com> <20071018.044611.21595530.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018.044611.21595530.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2007 at 04:46:11AM -0700, David Miller wrote:
> From: "Shane Huang" <Shane.Huang@amd.com>
> Date: Thu, 18 Oct 2007 18:37:59 +0800
> 
> > Hi Miller:
> > 
> > Thank you for your response.
> > 
> > The reason why MSIs of these northbridges do not work is still under
> > further debug, we are NOT able to tell its hardware issue or software
> > issue at this  time. But enablement of them will lead to the OS
> > installation failure in many distributions like openSUSE, Ubuntu etc:
> > https://bugzilla.novell.com/show_bug.cgi?id=302016
> > 
> > So we have to disable them firstly before we find out the root cause,
> > maybe they are just workarounds.
> 
> This logic seems backwards, to me.  "shoot first, ask questions later"
> To me this it not how to approach this problem.
> 
> Once you turn MSI off, there is next to no incentive to fix the
> problem because users aren't running into it any longer.

I agree with David here.  Please work to find the root cause of this
problem.  If it turns out that all of these chipsets have broken MSI and
can't handle it at all (oops, that's a major bug...) then we will accept
this patch.

But for now, let's not take a band-aid that prevents others from working
to solve the real issues here.

thanks,

greg k-h
