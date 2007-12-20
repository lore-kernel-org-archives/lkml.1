Return-Path: <linux-kernel-owner+w=401wt.eu-S1761834AbXLTWoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761834AbXLTWoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755566AbXLTWoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:44:11 -0500
Received: from ns2.suse.de ([195.135.220.15]:54301 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133AbXLTWoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:44:08 -0500
Date: Thu, 20 Dec 2007 14:40:06 -0800
From: Greg KH <gregkh@suse.de>
To: Tony Camuso <tcamuso@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
Message-ID: <20071220224006.GA16855@suse.de>
References: <476A5FD0.4010804@redhat.com> <20071220172205.GB5636@suse.de> <476AB3B5.9080808@redhat.com> <20071220215719.GA8528@suse.de> <476AEE7B.6050708@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476AEE7B.6050708@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 05:36:43PM -0500, Tony Camuso wrote:
> Greg KH wrote:
>> On Thu, Dec 20, 2007 at 01:25:57PM -0500, Tony Camuso wrote:
>> Any reason why these changes were never submitted to the upstream kernel
>> versions?  Or do you all just want to keep patching your newer releases
>> with this information forever?  :)
>
> I really don't know why these changes were never submitted to the
> upstream kernel versions".
>
> I was brought on the scene about six months ago as HP's on-site engineer
> at RH, and this was one of the things they wanted me to do.
>
> We wanted a solution that was more generic and could manage this
> problem preemptively, rather than using blacklists. Maintenance of
> blacklists is a bother and almost always done after a new system
> with this problem is discovered.
>
> Furthermore, blacklisting whole platforms to use legacy pci config
> penalizes any mmconfig-friendly buses in those platforms, particularly
> the pci express buses, and causes such platforms to be non-compliant
> with the pci expres spec.

Sure, I realize this, but it solves the problem in one way for broken
hardware, such that it at least allows it to work, right?  It also
provides a better incentive for the manufacturer to fix their bios,
which as you are on-site at HP, it would seem odd that they would just
not do that instead of trying to work around this in the kernel...

thanks,

greg k-h
