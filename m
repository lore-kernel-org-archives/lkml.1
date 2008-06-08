Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbYFHReq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbYFHReq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 13:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753752AbYFHReg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 13:34:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:60568 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154AbYFHRef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 13:34:35 -0400
From: Andreas Schwab <schwab@suse.de>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Vegard Nossum <vegard.nossum@gmail.com>, geert@linux-m68k.org,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>, zippel@linux-m68k.org,
       Sam Ravnborg <sam@ravnborg.org>,
       Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] Speed up "make headers_*"
References: <20080608094730.GA30098@uranus.ravnborg.org>
	<19f34abd0806080312j2b09179cpa384a0460af5874e@mail.gmail.com>
	<20080608104122.GA10545@uranus.ravnborg.org>
	<1212922141.32207.495.camel@pmac.infradead.org>
	<20080608111707.GB10545@uranus.ravnborg.org>
	<1212931024.32207.546.camel@pmac.infradead.org>
	<2ccd2be2a739abf56d86266d5041bf07@kernel.crashing.org>
X-Yow: I'm changing the CHANNEL..  But all I get is commercials
 for ``RONCO MIRACLE BAMBOO STEAMERS''!
Date: Sun, 08 Jun 2008 19:34:28 +0200
In-Reply-To: <2ccd2be2a739abf56d86266d5041bf07@kernel.crashing.org> (Segher
	Boessenkool's message of "Sun, 8 Jun 2008 19:06:46 +0200")
Message-ID: <jeod6b25ln.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Segher Boessenkool <segher@kernel.crashing.org> writes:

>> Assuming we _don't_ want the ac_ahz member to be included on m68k, this
>> should fix it (is __mc68000__ the right thing to use?)...
>
> I think __m68k__ is preferred, it's harder to confuse for one of the
> tuning symbols (that is, __mc68040__ and friends).

__m68k__ wasn't pre-defined by gcc before 3.4.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
