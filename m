Return-Path: <linux-kernel-owner+w=401wt.eu-S1758640AbYHHSDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640AbYHHSDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 14:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbYHHSDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 14:03:08 -0400
Received: from testure.choralone.org ([194.9.77.134]:46428 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbYHHSDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 14:03:06 -0400
Date: Fri, 8 Aug 2008 14:03:47 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: mark.langsdorf@amd.com, lkml <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] powernow-k8: fix build errors
Message-ID: <20080808180347.GQ26295@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Randy Dunlap <randy.dunlap@oracle.com>, mark.langsdorf@amd.com,
	lkml <linux-kernel@vger.kernel.org>,
	akpm <akpm@linux-foundation.org>
References: <20080808101950.7a942fa6.randy.dunlap@oracle.com> <20080808173822.GP26295@codemonkey.org.uk> <20080808105040.291097a2.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808105040.291097a2.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 10:50:40AM -0700, Randy Dunlap wrote:
 > On Fri, 8 Aug 2008 13:38:22 -0400 Dave Jones wrote:
 > 
 > > I think something like below may be better..
 > > Same thing, but with one less ifdef ?
 > 
 > Close, but no cigar.

Yeah, that's what you get for posting before building.
 
 > > diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
 > > index 7a09ba4..3ba6fd2 100644
 > > --- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
 > > +++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
 > > @@ -951,6 +951,7 @@ static void powernow_k8_cpu_exit_acpi(struct powernow_k8_data *data)
 > >  }
 > >  
 > >  #else
 > > +static int powernow_k8_cpu_preinit_acpi(struct powernow_k8_data *data) { return -ENODEV; }
 > (void) // parameters

I made the same change locally.
 
 > (your) new patch:

I'll punt this on to Linus with your Signed-off-by: and Marks ACKed by.

thanks,

	Dave
 
-- 
http://www.codemonkey.org.uk
