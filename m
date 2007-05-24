Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbXEXViz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbXEXViz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbXEXVir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:38:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275AbXEXViq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:38:46 -0400
Date: Thu, 24 May 2007 17:37:42 -0400
From: Dave Jones <davej@redhat.com>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <len.brown@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Display Intel Dynamic Acceleration feature in /proc/cpuinfo
Message-ID: <20070524213742.GB5380@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Venki Pallipadi <venkatesh.pallipadi@intel.com>,
	Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
	Len Brown <len.brown@intel.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20070523224637.GB15887@linux-os.sc.intel.com> <200705242308.38360.ak@suse.de> <20070524211337.GB3692@linux-os.sc.intel.com> <200705242325.28011.ak@suse.de> <20070524212806.GA5249@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070524212806.GA5249@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 02:28:06PM -0700, Venki Pallipadi wrote:

 > > But actually reading the patch: it seems weird to detect the flag 
 > > in acpi-cpufreq and essentially change /proc/cpuinfo when a
 > > module is loaded. Why not in the intel setup function? And why is it 
 > > not in the standard CPUID 1 features mask anyways?
 > 
 > I can do it in intel setup function. But, the feature may not be activated
 > unless the driver is loaded.

The same could be said about est, vmx, and probably some others ;-)

	Dave

-- 
http://www.codemonkey.org.uk
