Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbZJ1SDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbZJ1SDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 14:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbZJ1SDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 14:03:06 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:57807 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbZJ1SDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 14:03:05 -0400
Authentication-Results: sj-iport-3.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAPYj6EqrR7Ht/2dsb2JhbADCIpguhD8E
X-IronPort-AV: E=Sophos;i="4.44,641,1249257600"; 
   d="scan'208";a="199444381"
From: Roland Dreier <rdreier@cisco.com>
To: Mike Travis <travis@sgi.com>
Cc: Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH] x86, mce: disable MCE if cpu has no MCE banks
References: <adaeip473qt.fsf@cisco.com> <4AE74D25.8090901@sgi.com>
	<4AE75DB9.3040702@sgi.com> <4AE7C396.7040109@jp.fujitsu.com>
	<4AE7D59D.9070307@linux.intel.com> <4AE7E40F.20602@jp.fujitsu.com>
	<4AE7E931.6040703@linux.intel.com> <ada8wevtpbk.fsf@cisco.com>
	<4AE88151.8000608@sgi.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 28 Oct 2009 11:03:07 -0700
In-Reply-To: <4AE88151.8000608@sgi.com> (Mike Travis's message of "Wed, 28 Oct
	2009 10:37:21 -0700")
Message-ID: <adar5sns8f8.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Oct 2009 18:03:08.0020 (UTC) FILETIME=[E7752340:01CA57F8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > > But would we want to accumulate all the different combinations of banks
 > > along with a CPU mask and then print something like:
 > >
 > >  CPUs 0 4: MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 SHD:8
 > >  CPUs 1 2 3 5 6 7: MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
 > >  CPUs 8 9 10 11 12 13 14 15: MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
 > 
 > Or use a cpumask and cpulist_scnprintf which condenses the cpu list nicely.

Thanks!  I didn't know about that API.

However with that said I think the real issue is whether that style of
output is a good idea, no matter how nicely the CPU list is formatted :)

 - R.
