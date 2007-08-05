Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076AbXHEEPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbXHEEPo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 00:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbXHEEPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 00:15:38 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:14045 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbXHEEPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 00:15:37 -0400
Date: Sun, 5 Aug 2007 07:15:31 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, riku.seppala@kymp.net,
       Andy Whitcroft <apw@shadowen.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: Oops in 2.6.23-rc1-git9, arch/x86_64/pci/k8-bus.c::fill_mp_bus_to_cpumask()
Message-ID: <20070805041531.GX25771@rhun.ibm.com>
References: <46B3A7BB.9000102@redhat.com> <200708041130.42038.ak@suse.de> <20070804093222.f0d7f3c7.akpm@linux-foundation.org> <200708050140.49590.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708050140.49590.ak@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2007 at 01:40:49AM +0200, Andi Kleen wrote:

> > "pci device ensure sysdata initialised", now at version 4.
> 
> Oh what a mess. I think I'll ask Linus to revert the sysdata patch
> instead. Clearly the stuff is half-baked

Personally I don't care that much, but I think you'll make jgarzik
very unhappy. The idea is also clearly the right way forward.

So far we know of a single regression and only with 'pci=noacpi'. How
about giving us a little bit of time to get to the bottom of it?
Unfortunately it's not reproducable on any of my machines, but I'm
looking into it.

Cheers,
Muli

