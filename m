Return-Path: <linux-kernel-owner+w=401wt.eu-S965747AbXAYJz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965747AbXAYJz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 04:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965750AbXAYJz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 04:55:29 -0500
Received: from raven.upol.cz ([158.194.120.4]:36603 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965747AbXAYJz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 04:55:29 -0500
To: Martin Drab <drab@kepler.fjfi.cvut.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Intel PCI-E bridge ACPI resources and possibly related SATA unstability problems on ASUS A8Js
Organization: Palacky University in Olomouc, experimental physics department.
In-Reply-To: <Pine.LNX.4.64.0701250142180.14408@kepler.fjfi.cvut.cz>
References: <Pine.LNX.4.64.0701250142180.14408@kepler.fjfi.cvut.cz>
Date: Thu, 25 Jan 2007 10:04:04 +0000
Message-Id: <E1HA1Se-0002Y3-VQ@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

gmane.linux.kernel:
> Hi,

Hallo.

> recently I got my hands on an ASUS A8Js notebook (Core 2 Duo T7200,
> Intel 945 PM PCI-E Chipset, for details see attached log). After booting 
> the latest 2.6.20-rc5-git3 kernel (but the same behaviour occurs also with 
> the 2.6.19.2, didn't try any other), some strange behaviour can be 
> observed.

There were disscussions about mmconfig and what nightmare it brought to
PCI(E) configuration in scope of BIOS, chip bugs. Here's (one of) such:
<http://marc.theaimsgroup.com/?l=linux-kernel&m=116007091004503&w=2>

> At first the following messages appear in the log:
>
> ...
> [   40.303154] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
> [   40.303157] PCI: Not using MMCONFIG.
>
> (not sure whether this is really a problem)

I think it may be the major problem.

____
