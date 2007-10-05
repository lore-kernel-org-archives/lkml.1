Return-Path: <linux-kernel-owner+w=401wt.eu-S932278AbXJEVRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278AbXJEVRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 17:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763457AbXJEVRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 17:17:25 -0400
Received: from ns.suse.de ([195.135.220.2]:39613 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763034AbXJEVRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 17:17:25 -0400
From: Andreas Schwab <schwab@suse.de>
To: Timur Tabi <timur@freescale.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: __LITTLE_ENDIAN vs. __LITTLE_ENDIAN_BITFIELD
References: <4706822D.4070509@freescale.com>
	<Pine.LNX.4.64.0710052031310.13406@fbirervta.pbzchgretzou.qr>
	<470691EB.7020209@freescale.com>
	<Pine.LNX.4.64.0710052138070.13406@fbirervta.pbzchgretzou.qr>
	<470694E0.7030408@freescale.com> <jed4vtnxa5.fsf@sykes.suse.de>
	<47069982.9030009@freescale.com>
X-Yow: I'm thinking about DIGITAL READ-OUT systems and
 computer-generated IMAGE FORMATIONS..
Date: Fri, 05 Oct 2007 23:17:22 +0200
In-Reply-To: <47069982.9030009@freescale.com> (Timur Tabi's message of "Fri\,
	05 Oct 2007 15\:07\:30 -0500")
Message-ID: <jezlyxmfbx.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi <timur@freescale.com> writes:

> Then I don't understand that point of defining __LITTLE_ENDIAN_BITFIELD.
> What does it mean for a C-level bitfield ordering to be little-endian if
> the processor is BIG_ENDIAN?

Byte endianess and bit endianness are orthogonal concecpts.  A cpu can
have insns using both little and big endian bit addressing (btst
vs. bftst on m68k).  The bitfield ordering is a property of the ABI and
may even be different from how the cpu numbers the bits in its ISA.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
