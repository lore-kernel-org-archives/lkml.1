Return-Path: <linux-kernel-owner+w=401wt.eu-S1753011AbXFFJBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbXFFJBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 05:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbXFFJA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 05:00:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:34779 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbXFFJA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 05:00:56 -0400
From: Andreas Schwab <schwab@suse.de>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Segher Boessenkool <segher@kernel.crashing.org>,
       Kyle Moffett <mrmacman_g4@mac.com>, John Stoffel <john@stoffel.org>,
       Willy Tarreau <w@1wt.eu>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       CaT <cat@zip.com.au>, Ondrej Zajicek <santiago@crfreenet.org>,
       linux-kernel@vger.kernel.org, Bill Davidsen <davidsen@tmr.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Thomas Gleixner <tglx@linutronix.de>, Dongjun Shin <djshin90@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Arnd Bergmann <arnd@arndb.de>,
       Albert Cahalan <acahalan@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org,
       Artem Bityutskiy <dedekind@infradead.org>,
       Sam Ravnborg <sam@ravnborg.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       Pavel Machek <pavel@ucw.cz>, Ulisses Furquim <ulissesf@gmail.com>,
       akpm@osdl.org, David Weinehall <tao@acc.umu.se>
Subject: Re: [Patch 04/18] include/linux/logfs.h
References: <20070603183845.GA8952@lazybastard.org>
	<20070603184205.GE8952@lazybastard.org>
	<200706032342.27252.arnd@arndb.de>
	<20070604091245.GF14823@lazybastard.org>
	<1180964303.25232.358.camel@pmac.infradead.org>
	<18f622d94e9273fe6c93ef091fcec87c@kernel.crashing.org>
	<1181058836.16089.23.camel@hades.cambridge.redhat.com>
	<db91817d295770e459727005108b05e2@kernel.crashing.org>
	<1181119820.25232.434.camel@pmac.infradead.org>
X-Yow: Everybody is going somewhere!!  It's probably a garage sale
 or a disaster Movie!!
Date: Wed, 06 Jun 2007 10:59:48 +0200
In-Reply-To: <1181119820.25232.434.camel@pmac.infradead.org> (David
	Woodhouse's message of "Wed\, 06 Jun 2007 09\:50\:20 +0100")
Message-ID: <jemyzdpiez.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse <dwmw2@infradead.org> writes:

> Won't a simple struct { uint16_t } get padded to a size of 4 bytes on
> ARM? Even if I'm misremembering that, I certainly can't guarantee that
> such a thing will _never_ happen on any newly-invented ABI. If you had
> 'nopadding' instead of 'packed', then there's no need to emit code to
> handle unaligned loads.

You can add aligned(N) to increase the alignment again.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
