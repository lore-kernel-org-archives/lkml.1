Return-Path: <linux-kernel-owner+w=401wt.eu-S1755082AbZFIPSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbZFIPSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 11:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbZFIPSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 11:18:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:60220 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564AbZFIPSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 11:18:00 -0400
Subject: Re: [PATCH] X86: cpu_debug support for VIA / Centaur CPU's
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Harald Welte <HaraldWelte@viatech.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090609145305.GD3986@prithivi.gnumonks.org>
References: <20090609082931.GD25316@prithivi.gnumonks.org>
	 <1244537598.2558.9.camel@ht.satnam>
	 <20090609145305.GD3986@prithivi.gnumonks.org>
Content-Type: text/plain
Date: Tue, 09 Jun 2009 20:48:50 +0530
Message-Id: <1244560731.2509.32.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-09 at 22:53 +0800, Harald Welte wrote:
> Thanks for your quick response.
> 
> On Tue, Jun 09, 2009 at 02:23:18PM +0530, Jaswinder Singh Rajput wrote:
>  
> > On Tue, 2009-06-09 at 16:29 +0800, Harald Welte wrote:
> > > This patch adds the MSR definitions for the VIA/Centaur CPU models
> > > to cpu_debug.c
> > > 
> > > Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
> > 
> > As per Ingo suggestion, we removed model information from cpu_debug and
> > is available in -tip :
> 
> but what happens if one MSR has a different group from vendor A to vendor B?
> and what happens if you read MSR's on a CPU that doesn't have them?  I suppose
> you get a segmentation fault, at least that's what I've received in the past
> when accidentially reading a MSR that doesn't exist.  Is that what the _safe_
> variant of rdmsr is for?
> 

AFAIK we are using safe variant. That's why I requested you to test
latest -tip and let us know your result and feedback.

> > 
> > Currently I am doing more changes and available in :
> > 
> > http://git.kernel.org/?p=linux/kernel/git/jaswinder/linux-2.6-cpu.git;a=shortlog;h=x86/cpu
> 
> Which means I should base on which of those tree to make sure it can be merged?
> 

-tip will be better option.

Thanks,
--
JSR

