Return-Path: <linux-kernel-owner+w=401wt.eu-S1764589AbXJEXR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764589AbXJEXR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 19:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbXJEXRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 19:17:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44677 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbXJEXRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 19:17:20 -0400
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
	<4706A842.9030507@freescale.com> <jer6k9mesf.fsf@sykes.suse.de>
	<4706AD62.6030705@freescale.com>
X-Yow: JAPAN is a WONDERFUL planet -- I wonder if we'll ever reach
 their level of COMPARATIVE SHOPPING...
Date: Sat, 06 Oct 2007 01:17:18 +0200
In-Reply-To: <4706AD62.6030705@freescale.com> (Timur Tabi's message of "Fri\,
	05 Oct 2007 16\:32\:18 -0500")
Message-ID: <jeir5lm9s1.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi <timur@freescale.com> writes:

> Andreas Schwab wrote:
>> Timur Tabi <timur@freescale.com> writes:
>>
>>> The CPU shift operation, yes.  I'm talking about shift operations on
>>> external memory-mapped devices.
>>
>> That is a property of how the device is wired to the bus.  The cpu will
>> always put a value of 128 on the bus such that D7 = 1 and D0-D6 = 0.
>
> Yes, but is D7 on the left or on the right?

On the bus there is no left or right.  There is only D7 and D0.

> that there's no macro that will tell how the lines from the CPU to
> external memory are mapped.

This is always the same.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
