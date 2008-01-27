Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbYA0EqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbYA0EqZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 23:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbYA0EqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 23:46:16 -0500
Received: from mail.gmx.net ([213.165.64.20]:34760 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752996AbYA0EqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 23:46:15 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/ZWeB7g7zZBXeiKAKMHEq7INPC/wyvus6pfHd9FY
	EWiB/uCs9dxzjZ
Subject: Re: 2.6.24-rt1: timing problems (was [git pull] x86/hrtimer/acpi
	fixes)
From: Mike Galbraith <efault@gmx.de>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Len Brown <lenb@kernel.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@redhat.com>
In-Reply-To: <1201399193.18590.11.camel@cmn3.stanford.edu>
References: <20071207183633.GC26778@elte.hu>
	 <1197053386.32023.13.camel@cmn3.stanford.edu>
	 <20071207185920.GA3006@elte.hu>
	 <1197055769.32023.22.camel@cmn3.stanford.edu>
	 <1197056910.32023.25.camel@cmn3.stanford.edu>
	 <20071207195958.GA12529@elte.hu>
	 <1197076100.32023.67.camel@cmn3.stanford.edu>
	 <20071208091706.GB20516@elte.hu>
	 <1201399193.18590.11.camel@cmn3.stanford.edu>
Content-Type: text/plain
Date: Sun, 27 Jan 2008 05:46:08 +0100
Message-Id: <1201409168.5295.26.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-01-26 at 17:59 -0800, Fernando Lopez-Lezcano wrote:

> Hi Ingo... back to testing. 
> History:
> 
> 2.6.23.x + rt has not been very usable for audio applications. 
> 2.6.24-rt1: same so far. 
> 
> Why: Jack keeps printing "delayed..." messages and has xruns which means
> that somehow the timing is delayed more than what jack would think
> reasonable. As in the case with an old timing bug, the problem
> dissapears when booting the kernel with idle=poll. Other users of Planet
> CCRMA are able to replicate the behavior, which goes away with idle=poll
> or booting the machine with only one core. As a workaround I have been
> packaging 2.6.22.x but now I'm not able to use that as the old rt14
> patch, suitably tweaked results in a non working kernel. 
> 
> So it looks like, again, timing is getting skewed when the jack process
> jumps between cpus and thus jack sees timing jumps that are just not
> happenning. 
> 
> This is with a build based on 2.6.24 using as a base the latest Fedora
> rawhide source package plus 2.6.24-rt1. 

Do you have a simple testcase?  (one which doesn't entail installing
ccrma and becoming an audiophile)

	-Mike

