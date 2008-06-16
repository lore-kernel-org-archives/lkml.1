Return-Path: <linux-kernel-owner+w=401wt.eu-S1752078AbYFPLIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbYFPLIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 07:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbYFPLH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 07:07:56 -0400
Received: from cpsmtpo-eml02.kpnxchange.com ([213.75.38.151]:12390 "EHLO
	cpsmtpo-eml02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751758AbYFPLHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 07:07:55 -0400
From: Frans Pop <elendil@planet.nl>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [Bug 10843] Display artifacts on XOrg logout with PAT kernel and VESA framebuffer
Date: Mon, 16 Jun 2008 13:07:48 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik> <20080616004153.GA7788@linux-os.sc.intel.com> <200806161253.10656.elendil@planet.nl>
In-Reply-To: <200806161253.10656.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806161307.50029.elendil@planet.nl>
X-OriginalArrivalTime: 16 Jun 2008 11:07:50.0853 (UTC) FILETIME=[3789EF50:01C8CFA1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 June 2008, Frans Pop wrote:
> I do see some differences in Xorg logs, so it does seem that the mtrr
> options _are_ being recognized.
> Attached my "normal" Xorg log (with 'vga=791') which I used as the base
> for the diffs below. Other than shown, the logs are identical.
>
> With mtrr:1 I get (added at the end of the log):
> @@ -688,3 +688,11 @@
>  (II) evaluating device (Generic Keyboard)
>  (II) XINPUT: Adding extended input device "Generic Keyboard" (type:
> KEYBOARD)
> (II) Configured Mouse: ps2EnableDataReporting: succeeded 
> +(II) intel(0): xf86UnbindGARTMemory: unbind key 0
> +(II) intel(0): xf86UnbindGARTMemory: unbind key 1
> +(II) intel(0): xf86UnbindGARTMemory: unbind key 2
> +(II) intel(0): xf86UnbindGARTMemory: unbind key 3
> +(II) intel(0): xf86UnbindGARTMemory: unbind key 4
> +(II) intel(0): [drm] removed 1 reserved context for kernel
> +(II) intel(0): [drm] unmapping 8192 bytes of SAREA 0x2efff000 at
> 0x7f2788ab9000
> +(II) intel(0): [drm] Closed DRM master. 

Oops. Just realized that this is completely bogus. I used the .old log for 
this one while I used logs for still running Xorg sessions for the 
others. So this was actually the only one that contains Xorg shutdown 
messages at all.

> And with mtrr:3 (added in the middle):
> @@ -577,6 +577,7 @@
>  (II) intel(0): [drm] Initialized kernel agp heap manager, 33554432
>  (II) intel(0): [dri] visual configs initialized
>  (II) intel(0): Page Flipping disabled
> +(==) intel(0): Removed MMIO write-combining range
> (0x80000000,0x400000)
> (==) intel(0): Write-combining range (0x80000000,0x10000000)
>  (II) intel(0): vgaHWGetIOBase: hwp->IOBase is 0x03d0, hwp->PIOOffset
> is 0x0000
> (II) EXA(0): Offscreen pixmap area of 39321600 bytes 

This is still valid though.

Sorry for the confusion.
