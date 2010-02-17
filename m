Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab0BQWCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 17:02:33 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:49436 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751446Ab0BQWCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 17:02:31 -0500
Date: Wed, 17 Feb 2010 16:37:41 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: david@lang.hm
Cc: Volker Armin Hemmann <volkerarmin@googlemail.com>,
       Kyle Moffett <kyle@moffetthome.net>,
       Rudy Zijlstra <rudy@grumpydevil.homelinux.org>,
       Neil Brown <neilb@suse.de>,
       "Mr. James W. Laferriere" <babydr@baby-dragons.com>,
       Bill Davidsen <davidsen@tmr.com>, Michael Evans <mjevans1983@gmail.com>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: Linux mdadm superblock question.
Message-ID: <20100217213741.GA16938@emergent.ellipticsemi.com>
Mail-Followup-To: david@lang.hm,
	Volker Armin Hemmann <volkerarmin@googlemail.com>,
	Kyle Moffett <kyle@moffetthome.net>,
	Rudy Zijlstra <rudy@grumpydevil.homelinux.org>,
	Neil Brown <neilb@suse.de>,
	"Mr. James W. Laferriere" <babydr@baby-dragons.com>,
	Bill Davidsen <davidsen@tmr.com>,
	Michael Evans <mjevans1983@gmail.com>, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org
References: <201002140251.59668.volkerarmin@googlemail.com>
 <alpine.DEB.2.00.1002170932010.4721@asgard.lang.hm>
 <20100217181016.GA14983@emergent.ellipticsemi.com>
 <201002171927.07051.volkerarmin@googlemail.com>
 <20100217183703.GA15446@emergent.ellipticsemi.com>
 <alpine.DEB.2.00.1002171040350.4721@asgard.lang.hm>
 <20100217185105.GA15614@emergent.ellipticsemi.com>
 <alpine.DEB.2.00.1002171317080.4721@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1002171317080.4721@asgard.lang.hm>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:17 Wed 17 Feb     , david@lang.hm wrote:
> On Wed, 17 Feb 2010, Nick Bowler wrote:
> 
> > On 10:41 Wed 17 Feb     , david@lang.hm wrote:
> >> On Wed, 17 Feb 2010, Nick Bowler wrote:
> >>> It takes about half a second for mdadm to assemble my root array, is
> >>> that what you're referring to?
> >>>
> >>> I assume that kernel auto-assembly is no faster, although I've never
> >>> used it.  Regardless, half a second isn't very long to wait.
> >>
> >> If you are aiming for a 5-second boot time it's 10% of your total boot
> >> time. That's a lot for a feature that's not needed.
> >
> > Only if the kernel auto-assembly takes zero time, which it obviously
> > does not.
> 
> the assembly time would probably be the same, but the initramfs being 
> proposed did not include that time either.

This was the *only* time that was included.  Quoting myself:

> It takes about half a second for mdadm to assemble my root array

I didn't make any claim about any other timings, since I have not made
any measurements (I am not adding instrumentation code to my initramfs
and rebooting the box just to do this, and my watch is not precise
enough to measure the time spent in initramfs).

After the kernel has loaded, but before init on my root fs is run, there
are only three things that cause noticeable delays:

 * probing all the disks.
 * assembling the root array.
 * mounting the root filesystem.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
