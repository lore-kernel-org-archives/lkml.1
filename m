Return-Path: <linux-kernel-owner+w=401wt.eu-S1758306AbXHEFE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306AbXHEFE3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 01:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbXHEFEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 01:04:22 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:40885 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbXHEFEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 01:04:22 -0400
Date: Sun, 5 Aug 2007 08:04:10 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, riku.seppala@kymp.net,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: Oops in 2.6.23-rc1-git9, arch/x86_64/pci/k8-bus.c::fill_mp_bus_to_cpumask()
Message-ID: <20070805050410.GB4960@rhun.haifa.ibm.com>
References: <46B3A7BB.9000102@redhat.com> <200708041130.42038.ak@suse.de> <20070804093222.f0d7f3c7.akpm@linux-foundation.org> <200708050140.49590.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708050140.49590.ak@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2007 at 01:40:49AM +0200, Andi Kleen wrote:

> Oh what a mess. I think I'll ask Linus to revert the sysdata patch
> instead. Clearly the stuff is half-baked

By the way, Andi, just making sure you're aware the issue Andy's patch
addresses is separate from the 2.6.23-rc1 ->sysdata breakage? 
Reverting my and jgarzik's sysdata patch won't fix Andy's issue.

Cheers,
Muli
