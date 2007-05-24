Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbXEXVBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbXEXVBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbXEXVBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:01:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbXEXVBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:01:41 -0400
Date: Thu, 24 May 2007 17:01:04 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <len.brown@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Display Intel Dynamic Acceleration feature in /proc/cpuinfo
Message-ID: <20070524210103.GA5380@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Venki Pallipadi <venkatesh.pallipadi@intel.com>,
	Len Brown <len.brown@intel.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <ak@suse.de>
References: <20070523224637.GB15887@linux-os.sc.intel.com> <20070524135513.b6efacbf.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070524135513.b6efacbf.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 01:55:13PM -0700, Andrew Morton wrote:
 > On Wed, 23 May 2007 15:46:37 -0700
 > Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:
 > 
 > > Display Intel Dynamic Acceleration feature in /proc/cpuinfo. This feature
 > > will be enabled automatically by current acpi-cpufreq driver and cpufreq.
 > 
 > So you're saying that the cpufreq code in Linus's tree aleady supports IDA?
 > If so, this is a 2.6.22 patch, isn't it?

>From my limited understanding[*], ida is the "We're single threaded,
disable the 2nd core, and clock the first core faster" magic.
It doesn't need code-changes, as its all done in hardware afaik.

identifying & exporting the flags on earlier kernels should be harmless,
but not really 'mustfix'.

	Dave

[*] As in I've read about this more on the inquirer etc than
I have on Intel docs so far.  ;-)

-- 
http://www.codemonkey.org.uk
