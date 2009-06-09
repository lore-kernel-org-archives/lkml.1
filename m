Return-Path: <linux-kernel-owner+w=401wt.eu-S1754922AbZFIPAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbZFIPAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 11:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbZFIPAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 11:00:09 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:43116 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbZFIPAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 11:00:08 -0400
Date: Tue, 9 Jun 2009 22:53:05 +0800
From: Harald Welte <HaraldWelte@viatech.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] X86: cpu_debug support for VIA / Centaur CPU's
Message-ID: <20090609145305.GD3986@prithivi.gnumonks.org>
References: <20090609082931.GD25316@prithivi.gnumonks.org> <1244537598.2558.9.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244537598.2558.9.camel@ht.satnam>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your quick response.

On Tue, Jun 09, 2009 at 02:23:18PM +0530, Jaswinder Singh Rajput wrote:
 
> On Tue, 2009-06-09 at 16:29 +0800, Harald Welte wrote:
> > This patch adds the MSR definitions for the VIA/Centaur CPU models
> > to cpu_debug.c
> > 
> > Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
> 
> As per Ingo suggestion, we removed model information from cpu_debug and
> is available in -tip :

but what happens if one MSR has a different group from vendor A to vendor B?
and what happens if you read MSR's on a CPU that doesn't have them?  I suppose
you get a segmentation fault, at least that's what I've received in the past
when accidentially reading a MSR that doesn't exist.  Is that what the _safe_
variant of rdmsr is for?

> Please check latest -tip from and see how it works with your chips :

I suppose it works, but it probably lacks all the via/centaur specific MSR's.
I'll work on a patch as soon as i find time.

> git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip.git
> 
> Currently I am doing more changes and available in :
> 
> http://git.kernel.org/?p=linux/kernel/git/jaswinder/linux-2.6-cpu.git;a=shortlog;h=x86/cpu

Which means I should base on which of those tree to make sure it can be merged?

-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Free and Open Source Software Liaison
