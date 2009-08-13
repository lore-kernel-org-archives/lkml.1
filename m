Return-Path: <linux-kernel-owner+w=401wt.eu-S1752340AbZHMFjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbZHMFjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 01:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbZHMFjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 01:39:11 -0400
Received: from mail.gmx.net ([213.165.64.20]:57699 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752016AbZHMFjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 01:39:10 -0400
X-Authenticated: #2360897
X-Provags-ID: V01U2FsdGVkX1/BMjxWdcHBjsvV9uwAfHtcwVQeqhVNWoL40qKC/m
	aygkdDDXMPSILq
Date: Thu, 13 Aug 2009 07:39:52 +0200
From: Bernhard Walle <bernhard.walle@gmx.de>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 0/8] V3 Implement crashkernel=auto
Message-ID: <20090813053952.GA9037@mail1.bwalle.de>
References: <20090812081731.5757.25254.sendpatchset@localhost.localdomain>
 <20090812124659.GA4808@mail1.bwalle.de>
 <4A837F49.9060003@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A837F49.9060003@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Amerigo Wang <amwang@redhat.com> [2009-08-13 04:49]:
> Bernhard Walle wrote:
> >
> >Honestly I don't see why everything is guarded by
> >CONFIG_KEXEC_AUTO_RESERVE. We do we need that new configuration
> >option? I mean, if I don't specify 'crashkernel=auto', then the patch
> >does nothing, right? Then the option CONFIG_KEXEC_AUTO_RESERVE would
> >only be needed so save some bytes of code. Is that really worth it?
> 
> Hi,  CONFIG_KEXEC_AUTO_RESERVE is not for saving bytes, it just
> provides a choice for the user to decide to enable it or not.

Still, I don't understand it. When I don't say "crashkernel=auto" on
command line, then nothing is done, right? So the choice for the user
is the "crashkernel=auto". Why do we need CONFIG_KEXEC_AUTO_RESERVE
then? Maybe I just missed something in my logic ...


Regards,
Bernhard
