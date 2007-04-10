Return-Path: <linux-kernel-owner+w=401wt.eu-S965744AbXDJE3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965744AbXDJE3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 00:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030332AbXDJE3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 00:29:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965744AbXDJE3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 00:29:45 -0400
Date: Tue, 10 Apr 2007 00:29:39 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Jeff V. Merkey" <jmerkey@wolfmountaingroup.com>,
       Linux kernel <linux-kernel@vger.kernel.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: Preemption Broken:  centrino_target busted under SMP on 2.6.20.4
Message-ID: <20070410042939.GA17179@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Jeff V. Merkey" <jmerkey@wolfmountaingroup.com>,
	Linux kernel <linux-kernel@vger.kernel.org>,
	Venki Pallipadi <venkatesh.pallipadi@intel.com>
References: <46155CFF.70701@wolfmountaingroup.com> <20070405205034.GB3605@redhat.com> <20070409172651.9bc619d6.akpm@linux-foundation.org> <20070410023108.GA14081@redhat.com> <20070409194142.88f0a5e5.akpm@linux-foundation.org> <20070410030500.GA15509@redhat.com> <20070410030823.GA16229@redhat.com> <20070409205136.75709d3e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070409205136.75709d3e.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 08:51:36PM -0700, Andrew Morton wrote:
 > On Mon, 9 Apr 2007 23:08:23 -0400 Dave Jones <davej@redhat.com> wrote:
 > 
 > >  > This whole file is going away in .22, and we have a viable alternative in
 > >  > .21 (acpi-cpufreq), so I'm not overly worried about fixing this up
 > >  > given it only shows up in debug kernels, especially at this stage in -rc.
 > >  > 
 > >  > (Yeah, it's a cop-out, but unless someone with more interest in this problem
 > >  >  steps up, I've bigger fishes to fry).
 > > 
 > > One last try...
 > > (I didn't think too long about this, so this might be equally busted,
 > >  but if so, see comment above).
 > 
 > Yes, I expect that should squish the warnings.  It looks all racy wrt cpu hotplug
 > and against async set_cpus_allowed(), but if those are our worst problems, we're
 > good.

It probably needs a couple more preempt_enable()'s sprinkled throughout the function
to take care of the break's. I also missed a goto case.
Meh, this cure is as bad as the disease.

	Dave

-- 
http://www.codemonkey.org.uk
