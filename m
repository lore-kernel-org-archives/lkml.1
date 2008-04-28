Return-Path: <linux-kernel-owner+w=401wt.eu-S937095AbYD1Q4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937095AbYD1Q4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937028AbYD1Q4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:56:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:43558 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937021AbYD1Q4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:56:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,717,1199692800"; 
   d="scan'208";a="558022198"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Mika Fischer <mika.fischer@zoopnet.de>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
Date: Mon, 28 Apr 2008 09:55:53 -0700
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Gabriel C <nix.or.die@googlemail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       balajirrao@gmail.com, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200801192045.17291.yinghai.lu@sun.com> <200804280909.06561.jesse.barnes@intel.com> <4815FBD3.6050902@zoopnet.de>
In-Reply-To: <4815FBD3.6050902@zoopnet.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804280955.53592.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 28, 2008 9:31 am Mika Fischer wrote:
> Jesse Barnes schrieb:
> > On Monday, April 28, 2008 6:53 am Ingo Molnar wrote:
> >> i think we should still try to make this a non-default option because
> >> modern Xorg should not have any need to touch MTRRs. Perhaps a .config
> >> dependent on CONFIG_DANGEROUS ;-)
> >
> > Well, not quite... we're still waiting on some way of getting WC
> > semantics for sysfs PCI files.  Suresh tells me something like that is
> > queued up, but until that hits the mainline X will still need to bang the
> > MTRRs to get decent performance.
>
> Do you happen to know if this new sysfs-way will work correctly in the
> case where the MTRRs explicitly say that the video-memory is uncachable?

It should, since we'll be using PAT to set the cache control in the sysfs 
case.

Jesse
