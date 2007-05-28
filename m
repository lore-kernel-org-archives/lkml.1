Return-Path: <linux-kernel-owner+w=401wt.eu-S1761073AbXE1ObY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761073AbXE1ObY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 10:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758231AbXE1ObF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 10:31:05 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:56968 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757488AbXE1ObD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 10:31:03 -0400
Date: Mon, 28 May 2007 10:31:02 -0400
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org
Subject: Re: IDE/ATA: Intel i865-based mainboard, CDROM not detected
Message-ID: <20070528143101.GB10008@csclub.uwaterloo.ca>
References: <46585FAC.80208@tmr.com> <200705272307.l4RN7Ltk012112@turbo.physics.adelaide.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705272307.l4RN7Ltk012112@turbo.physics.adelaide.edu.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 08:37:21AM +0930, Jonathan Woithe wrote:
> The CDROM was showing up in the POST in all cases.
> 
> It turns out the problem (as I outlined in a followup post) resulted from a
> combination of issues.
> 
>  1) This board uses a Marvell PATA controller, so the relevant driver must
>     be configured.
> 
>  2) Unless the "Configure SATA as" setting in the BIOS is set to "AHCI" the
>     PATA controller won't be found.  Sounds a bit odd and counter-intuitive,
>     but that's what's happening.  Originally this item was set to IDE; the
>     other option is RAID but I haven't tested that.

Maybe the SATA pretending to be PATA took up the ports that the marvell
PATA needed to provide PATA, so in effect hidding the marvell.

--
Len Sorensen
