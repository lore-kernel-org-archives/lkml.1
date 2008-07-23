Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbYGWDWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbYGWDWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 23:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbYGWDWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 23:22:06 -0400
Received: from void.printf.net ([89.145.97.157]:44236 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142AbYGWDWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 23:22:06 -0400
X-Greylist: delayed 568 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jul 2008 23:22:05 EDT
From: Chris Ball <cjb@laptop.org>
To: linux-kernel@vger.kernel.org
Subject: Aperture pointing to e820 RAM. Ignoring.
Date: Tue, 22 Jul 2008 23:12:34 -0400
Message-ID: <m3wsjd2t0d.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a new 64-bit AMD system, with:

  00:00.0 Host bridge: Advanced Micro Devices [AMD] RS780 Host Bridge
  CPU0: AMD Phenom(tm) 9550 Quad-Core Processor stepping 03

dmesg contains:

  Checking aperture...
  No AGP bridge found
  Node 0: aperture @ 20000000 size 32 MB
  Aperture pointing to e820 RAM. Ignoring.
  Your BIOS doesn't leave a aperture memory hole
  Please enable the IOMMU option in the BIOS setup
  This costs you 64 MB of RAM

Any suggestions on how to get my 64 MB back?  Full dmesg at:

  http://dev.laptop.org/~cjb/pullcord-dmesg

As a small nitpick, the text quoted above seems misleading:

> Your BIOS doesn't leave a aperture memory hole

I don't think that's true; we just don't like where it mapped it.

> Please enable the IOMMU option in the BIOS setup

.. therefore, I don't think this is relevant.  My BIOS doesn't appear
to have such an option in any case.

> This costs you 64 MB of RAM

A literal interpretation of "Please enable the IOMMU option in the BIOS
setup / This costs you 64 MB of RAM" would be that turning on the
IOMMU option would cost me 64 MB of RAM, whereas I think the opposite
meaning is intended.

Happy to help with the nitpick, and would like to sort out the
underlying problem on this box, which is a Gateway DX4200-UB001A.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>
