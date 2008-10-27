Return-Path: <linux-kernel-owner+w=401wt.eu-S1751919AbYJ0O1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbYJ0O1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 10:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbYJ0O1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 10:27:21 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:4565 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYJ0O1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 10:27:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding:sender;
        b=sHHqyS0nFUilNohRt/MLGI8Y3paPpiBx+UJx8F+gqdp/yN24j454j/Smur/4vCL5uX
         oaGU3QhCM3LZy+7Rqmha/7fQRUDQ83XUgUyPD/wV0BO3+xfHbn1YqRKMYOCxWrbzqrAB
         SvmaCCDjXVd9XRnMMNeJoxX80lnFtOCWSWQaY=
Message-ID: <4905CFC3.1060907@tuffmail.co.uk>
Date: Mon, 27 Oct 2008 14:27:15 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: dri-devel@lists.sourceforge.net
CC: Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.28-rc1: [drm:i915] *ERROR* ... Disabling tiling
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What does this mean, should I do anything about it?  Is tiling nice to have?

It sounds like GEM broke something - though maybe it just added a more 
verbose error report.

System: EeePC 701
Kernel: v2.6.36-rc1-5-g23cf24c
Chipset: Intel mobile 915G-something
Regretably necessary kernel boot option: noapic


[    1.438441] Linux agpgart interface v0.103
[    1.438441] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
[    1.438441] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
[    1.443353] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    1.443353] [drm] Initialized drm 1.1.0 20060810
[    1.443353] pci 0000:00:02.0: PCI INT A -> Link[LNKA] -> GSI 5 
(level, low) -> IRQ 5
[    1.443353] pci 0000:00:02.0: setting latency timer to 64
[    1.443353] [drm:i915_gem_detect_bit_6_swizzle] *ERROR* Couldn't read 
from MCHBAR.  Disabling
tiling.
[    1.443353] [drm:i915_driver_load] *ERROR* failed to enable MSI


I expect noapic explains the MSI failure.  I can boot without noapic if 
necessary for testing, but I can't run with it because I get nasty hangs 
& reboots.  I don't see why that merits an *ERROR*... anyway, what I'm 
interested in is the "Disabling tiling".

Thanks
Alan
