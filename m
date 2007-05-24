Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbXEXVZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbXEXVZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbXEXVZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:25:37 -0400
Received: from mx1.suse.de ([195.135.220.2]:56025 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328AbXEXVZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:25:36 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] Display Intel Dynamic Acceleration feature in /proc/cpuinfo
Date: Thu, 24 May 2007 23:25:27 +0200
User-Agent: KMail/1.9.6
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <len.brown@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <20070523224637.GB15887@linux-os.sc.intel.com> <200705242308.38360.ak@suse.de> <20070524211337.GB3692@linux-os.sc.intel.com>
In-Reply-To: <20070524211337.GB3692@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705242325.28011.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 May 2007 23:13:37 Venki Pallipadi wrote:
> On Thu, May 24, 2007 at 11:08:38PM +0200, Andi Kleen wrote:
> > 
> > I think it's generally a good idea to push cpuinfo flags in earliest
> > as possible; just make sure we actually use the final name (so that we don't get
> > into a pni->sse3 mess again) 
> >  
> 
> ida is official name as in the Software Developer's Manual now. So, should
> not be a issue unless marketing folks change their mind in future :-)

Well they did sometimes in the past.

But actually reading the patch: it seems weird to detect the flag 
in acpi-cpufreq and essentially change /proc/cpuinfo when a
module is loaded. Why not in the intel setup function? And why is it 
not in the standard CPUID 1 features mask anyways?

-Andi
