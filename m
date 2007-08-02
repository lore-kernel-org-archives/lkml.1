Return-Path: <linux-kernel-owner+w=401wt.eu-S1754405AbXHBElQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbXHBElQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 00:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbXHBElD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 00:41:03 -0400
Received: from pcls2.std.com ([192.74.137.142]:52144 "EHLO TheWorld.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751290AbXHBElB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 00:41:01 -0400
From: Alan Curry <pacman@TheWorld.com>
Message-Id: <200708020440.l724edCT290676@shell01.TheWorld.com>
Subject: Re: [PATCH] powerpc: Pegasos keyboard detection
To: matt@genesi-usa.com (Matt Sealey)
Date: Thu, 2 Aug 2007 00:40:39 -0400 (EDT)
Cc: segher@kernel.crashing.org (Segher Boessenkool), linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <46B03561.9090800@genesi-usa.com> from "Matt Sealey" at Aug 01, 2007 08:25:21 AM
X-Mailer: ELM [version 2.5 PL2]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Sealey writes the following:
>
>Yeah please do a fixup for the boot wrapper.
>
>Or, if you have trouble, go into the firmware and type "nvedit", add
>these lines;
>
>" /isa/8042" find-device
>" 8042" encode-string device-type
>
>(then ctrl-c to exit and nvstore to run it on next reboot. Try it without
>the patch first, on the firmware console, just to be sure I got it right,
>because I can't test it here)

It works from the ok prompt but in the nvramrc it doesn't find the device.
(pci/isa nodes not created yet?)

But the larger point:

>
>You don't need to patch Linux at all. In fact for silly things like this
>I would recommend against it :)

If the workaround doesn't go into the kernel, everybody with affected
hardware has to individually find out about the bug (probably by experiencing
an annoying keyboardless boot) and fix it himself. Is that worth the
reduction in kernel clutter?

-- 
Alan Curry
pacman@world.std.com
