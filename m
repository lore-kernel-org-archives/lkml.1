Return-Path: <linux-kernel-owner+w=401wt.eu-S1763569AbXFTSoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763569AbXFTSoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760033AbXFTSdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:33:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:60393 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760064AbXFTSdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:33:19 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1+DmCAUu7iDyHcn5fVhbgcreqgBde7zfzwrdwOVMF
	QHQWoxw28AZfW6
Date: Wed, 20 Jun 2007 20:33:15 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Andi Kleen <ak@suse.de>
Cc: eranian@hpl.hp.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       levon@movementarian.org, perfmon@napali.hpl.hp.com,
       oprofile-list@lists.sourceforge.net, wcohen@redhat.com,
       akpm@linux-foundation.org
Subject: Re: [perfmon] Re: [PATCH 1/2] Separate the performance counter allocation from the LAPIC NMI watchdog
Message-ID: <20070620183315.GA3251@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Andi Kleen <ak@suse.de>, eranian@hpl.hp.com, mingo@elte.hu,
	linux-kernel@vger.kernel.org, levon@movementarian.org,
	perfmon@napali.hpl.hp.com, oprofile-list@lists.sourceforge.net,
	wcohen@redhat.com, akpm@linux-foundation.org
References: <20070618103214.GA12045@atjola.homenet> <200706201431.44014.ak@suse.de> <20070620124959.GB24906@frankl.hpl.hp.com> <200706201501.02582.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200706201501.02582.ak@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.20 15:01:02 +0200, Andi Kleen wrote:
> 
> > Once this is fixed (which is what Bjorn did), then I will agree with you.
> > For this, the allocator needs to be able to probe the CPU and initialize
> > its own data structures.
> 
> Ok that sounds reasonable. Please someone send a patch that does only 
> that.

OK, here come the bugfixes without any restructuring. The first patch
enables unconditional probing of the watchdog. The second makes the
perfmon nmi watchdog reserve the correct perfctr/evntsel.

Björn
