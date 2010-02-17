Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab0BQSKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 13:10:41 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:38003 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753452Ab0BQSKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 13:10:40 -0500
Date: Wed, 17 Feb 2010 13:10:16 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: david@lang.hm
Cc: Kyle Moffett <kyle@moffetthome.net>,
       Rudy Zijlstra <rudy@grumpydevil.homelinux.org>,
       Neil Brown <neilb@suse.de>,
       "Mr. James W. Laferriere" <babydr@baby-dragons.com>,
       Bill Davidsen <davidsen@tmr.com>,
       Volker Armin Hemmann <volkerarmin@googlemail.com>,
       Michael Evans <mjevans1983@gmail.com>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: Linux mdadm superblock question.
Message-ID: <20100217181016.GA14983@emergent.ellipticsemi.com>
Mail-Followup-To: david@lang.hm, Kyle Moffett <kyle@moffetthome.net>,
	Rudy Zijlstra <rudy@grumpydevil.homelinux.org>,
	Neil Brown <neilb@suse.de>,
	"Mr. James W. Laferriere" <babydr@baby-dragons.com>,
	Bill Davidsen <davidsen@tmr.com>,
	Volker Armin Hemmann <volkerarmin@googlemail.com>,
	Michael Evans <mjevans1983@gmail.com>, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org
References: <201002140251.59668.volkerarmin@googlemail.com>
 <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
 <201002141940.35716.volkerarmin@googlemail.com>
 <4B7AD35E.7000405@tmr.com>
 <alpine.LNX.2.01.1002161541370.24961@filesrv1.baby-dragons.com>
 <20100217130103.3ca65ef3@notabene.brown>
 <f73f7ab81002162234t531203ccue1f9ecc839c8ae42@mail.gmail.com>
 <4B7BB927.5000305@grumpydevil.homelinux.org>
 <f73f7ab81002170822j7e61455o6bee33d95c9648a1@mail.gmail.com>
 <alpine.DEB.2.00.1002170932010.4721@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1002170932010.4721@asgard.lang.hm>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09:41 Wed 17 Feb     , david@lang.hm wrote:
> for a distro that is trying to make one kernel image run on every
> possible type of hardware features like initramfs (and udev, modeules,
> etc) are wonderful.
> 
> however for people who run systems that are known ahead of time and
> static (and who build their own kernels instead of just relying on the
> distro default kernel), all of this is unnessesary complication, which
> leaves more room for problems to creep in.

Such people can easily construct an initramfs containing busybox and
mdadm with a shell script hardcoded to mount their root fs and run
switch_root.  It's a ~10 minute jobbie that only needs to be done once.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
