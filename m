Return-Path: <linux-kernel-owner+w=401wt.eu-S1764928AbXE2Uw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764928AbXE2Uw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750924AbXE2UwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:52:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbXE2UwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:52:14 -0400
Date: Tue, 29 May 2007 16:51:59 -0400
From: Dave Jones <davej@redhat.com>
To: Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>
Cc: Ed Sweetman <safemode2@comcast.net>, Duane Griffin <duaneg@dghda.com>,
       Prakash Punnoor <prakash@punnoor.de>,
       LKML <linux-kernel@vger.kernel.org>, Daniel Drake <dsd@gentoo.org>
Subject: Re: [PATCH] Kconfig powernow-k8 driver should depend on ACPI P-States driver
Message-ID: <20070529205159.GA26124@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>,
	Ed Sweetman <safemode2@comcast.net>,
	Duane Griffin <duaneg@dghda.com>,
	Prakash Punnoor <prakash@punnoor.de>,
	LKML <linux-kernel@vger.kernel.org>, Daniel Drake <dsd@gentoo.org>
References: <20070516011711.GE15763@ifa.hawaii.edu> <200705162039.02379.prakash@punnoor.de> <e9e943910705161253i75750876s1789b7844c87e97@mail.gmail.com> <20070516204807.GA23751@redhat.com> <20070518030436.GB20793@ifa.hawaii.edu> <464D2702.1060001@comcast.net> <20070518160108.GA28021@redhat.com> <20070522024743.GA21514@ifa.hawaii.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070522024743.GA21514@ifa.hawaii.edu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 04:47:43PM -1000, Joshua Hoblitt wrote:

apologies for the delay in getting back to this.

 > Here is cleaned up version of Ed's patch that I believe addresses Dave's
 > stylistic concerns applies the relevant changes to both x86 & x86_64.

The x86-64 version is a symlink to the i386 file, so is unnecessary.
(That trap catches people out regularly).

 > Signed-off-by: Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>

The patch content looks ok to me, Daniel, ack?


 > diff -Nurp linux-2.6.22-rc1-mm1.orig/arch/i386/kernel/cpu/cpufreq/Kconfig l=
 > inux-2.6.22-rc1-mm1/arch/i386/kernel/cpu/cpufreq/Kconfig
 > --- linux-2.6.22-rc1-mm1.orig/arch/i386/kernel/cpu/cpufreq/Kconfig  2007-04-=
 > 27 11:49:26.000000000 -1000
 > +++ linux-2.6.22-rc1-mm1/arch/i386/kernel/cpu/cpufreq/Kconfig   2007-05-21 16=
 > :20:47.000000000 -1000
 > @@ -90,10 +90,17 @@ config X86_POWERNOW_K8
 >       If in doubt, say N.
 > =20
 >  config X86_POWERNOW_K8_ACPI
 > -   bool
 > -   depends on X86_POWERNOW_K8 && ACPI_PROCESSOR
 > -   depends on !(X86_POWERNOW_K8 =3D y && ACPI_PROCESSOR =3D m)
 > +   bool "ACPI Support"

MIME damage prevents this from applying.

	Dave

-- 
http://www.codemonkey.org.uk
