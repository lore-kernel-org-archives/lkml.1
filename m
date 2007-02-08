Return-Path: <linux-kernel-owner+w=401wt.eu-S1030656AbXBHDeD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030656AbXBHDeD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 22:34:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030661AbXBHDeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 22:34:03 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:41812 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030656AbXBHDeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 22:34:00 -0500
Date: Wed, 7 Feb 2007 19:27:35 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Horms <horms@verge.net.au>
Cc: "Luck, Tony" <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, fastboot@lists.osdl.org,
       "Zou, Nanhai" <nanhai.zou@intel.com>, Khalid Aziz <khalid_aziz@hp.com>,
       Adrian Bunk <trivial@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH] [IA64] Include kexec.h in arch/ia64/kernel/process.c
Message-Id: <20070207192735.2d06e984.randy.dunlap@oracle.com>
In-Reply-To: <20070208021900.GB17585@verge.net.au>
References: <20070207064935.GB726@verge.net.au>
	<617E1C2C70743745A92448908E030B2A0117C67C@scsmsx411.amr.corp.intel.com>
	<20070208021900.GB17585@verge.net.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007 11:19:03 +0900 Horms wrote:

> On Wed, Feb 07, 2007 at 09:07:40AM -0800, Luck, Tony wrote:
> > > kexec.h is needed by arch/ia64/kernel/process.c so for the
> > > declaration of kexec_disable_iosapic() which is used in
> > > machine_shutdown().
> > 
> > > +#include <asm/kexec.h>
> > 
> > I merged this into your earlier change (moving machine_shutdown() into
> > process.c).  Linus pulled it last night.
> 
> Thanks
> 
> > I also added a "#ifdef CONFIG_KEXEC" around the call to
> > kexec_disable_iosapic() (because I first noticed that this was
> > undefined when building non-KEXEC kernels).  But perhaps it might have
> > been better to #define an empty stub for this function inside kexec.h
> > for the #ifndef CONFIG_KEXEC case?
> 
> Good catch :)

uh, every one of Andrew's commit emails now contains the line
at the end of my mail sig...  Try it sometimes^W often.


> I think that #define in the process.c vs an empty stub inside
> asm/kexec.h is really a style issue. I'm quite ok with things
> the way they are. But If you are more comfortable with the stub
> approach, I have no objections.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
