Return-Path: <linux-kernel-owner+w=401wt.eu-S1759329AbXGXVeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329AbXGXVeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 17:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbXGXVeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 17:34:16 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:36367
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbXGXVeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 17:34:15 -0400
X-Greylist: delayed 1670 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jul 2007 17:34:15 EDT
Date: Tue, 24 Jul 2007 14:06:07 -0700
To: Chris Snook <csnook@redhat.com>
Cc: Chris Friesen <cfriesen@nortel.com>, Tong Li <tong.n.li@intel.com>,
       mingo@elte.hu, linux-kernel@vger.kernel.org,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>,
       Con Kolivas <kernel@kolivas.org>
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
Message-ID: <20070724210607.GB32582@gnuppy.monkey.org>
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com> <46A53C88.6060006@redhat.com> <Pine.LNX.4.64.0707240954560.8026@tongli.jf.intel.com> <46A64002.8080103@redhat.com> <46A6576A.9020506@nortel.com> <46A66393.5000705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A66393.5000705@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 04:39:47PM -0400, Chris Snook wrote:
> Chris Friesen wrote:
>> We currently use CKRM on an SMP machine, but the only way we can get away 
>> with it is because our main app is affined to one cpu and just about 
>> everything else is affined to the other.
>
> If you're not explicitly allocating resources, you're just low-latency, not 
> truly realtime.  Realtime requires guaranteed resources, so messing with 
> affinities is a necessary evil.

You've mentioned this twice in this thread. If you're going to talk about this
you should characterize this more specifically because resource allocation is
a rather incomplete area in the Linux. Rebalancing is still an open research
problem the last time I looked.

Tong's previous trio patch is an attempt at resolving this using a generic
grouping mechanism and some constructive discussion should come of it.

bill

