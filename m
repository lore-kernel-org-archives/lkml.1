Return-Path: <linux-kernel-owner+w=401wt.eu-S1759446AbXE0XHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759446AbXE0XHg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 19:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbXE0XH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 19:07:29 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:51898 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752729AbXE0XH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 19:07:28 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200705272307.l4RN7Ltk012112@turbo.physics.adelaide.edu.au>
Subject: Re: IDE/ATA: Intel i865-based mainboard, CDROM not detected
To: davidsen@tmr.com (Bill Davidsen)
Date: Mon, 28 May 2007 08:37:21 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       linux-kernel@vger.kernel.org
In-Reply-To: <46585FAC.80208@tmr.com> from "Bill Davidsen" at May 26, 2007 12:26:20 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bill

> > A collegue of mine has an Intel mainboard with the i865 chipset onboard
> > (DQ965).  All kernels up to and including 2.6.22-rc2 do not detect the IDE
> > CDROM/DVDROM when booting.  The SATA hard drive is found without any
> > problems.
> > 
> Let me belatedly ask if the device shows up in POST at cold boot. It may 
> need some BIOS setting to be visible.

The CDROM was showing up in the POST in all cases.

It turns out the problem (as I outlined in a followup post) resulted from a
combination of issues.

 1) This board uses a Marvell PATA controller, so the relevant driver must
    be configured.

 2) Unless the "Configure SATA as" setting in the BIOS is set to "AHCI" the
    PATA controller won't be found.  Sounds a bit odd and counter-intuitive,
    but that's what's happening.  Originally this item was set to IDE; the
    other option is RAID but I haven't tested that.

Regards
  jonathan
--
"Time is an illusion; lunchtime doubly so"
