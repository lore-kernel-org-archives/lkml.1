Return-Path: <linux-kernel-owner+w=401wt.eu-S1764543AbXJEV3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764543AbXJEV3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 17:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763670AbXJEV3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 17:29:09 -0400
Received: from ns1.suse.de ([195.135.220.2]:40521 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763483AbXJEV3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 17:29:07 -0400
From: Andreas Schwab <schwab@suse.de>
To: Timur Tabi <timur@freescale.com>
Cc: Anton Altaparmakov <aia21@cam.ac.uk>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: __LITTLE_ENDIAN vs. __LITTLE_ENDIAN_BITFIELD
References: <4706822D.4070509@freescale.com>
	<Pine.LNX.4.64.0710052031310.13406@fbirervta.pbzchgretzou.qr>
	<470691EB.7020209@freescale.com>
	<AECA61F9-0EF6-4883-9D37-004C00C57417@cam.ac.uk>
	<4706A842.9030507@freescale.com>
X-Yow: Ha ha   Ha ha  Ha ha   Ha  Ha  Ha  Ha  -- When will I EVER stop HAVING
 FUN?!!
Date: Fri, 05 Oct 2007 23:29:04 +0200
In-Reply-To: <4706A842.9030507@freescale.com> (Timur Tabi's message of "Fri\,
	05 Oct 2007 16\:10\:26 -0500")
Message-ID: <jer6k9mesf.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi <timur@freescale.com> writes:

> The CPU shift operation, yes.  I'm talking about shift operations on
> external memory-mapped devices.

That is a property of how the device is wired to the bus.  The cpu will
always put a value of 128 on the bus such that D7 = 1 and D0-D6 = 0.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
