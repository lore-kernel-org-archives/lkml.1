Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbYGGKBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbYGGKBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 06:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbYGGKBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 06:01:17 -0400
Received: from ns1.suse.de ([195.135.220.2]:38537 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbYGGKBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 06:01:16 -0400
From: Andreas Schwab <schwab@suse.de>
To: Roland McGrath <roland@redhat.com>
Cc: benh@kernel.crashing.org, Nathan Lynch <ntl@pobox.com>,
       linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] elf loader support for auxvec base platform string
References: <20080703234140.GC9594@localdomain>
	<20080704021929.5E9EF1541F5@magilla.localdomain>
	<1215409693.8970.79.camel@pasglop>
	<20080707061811.19989154246@magilla.localdomain>
	<1215411800.8970.91.camel@pasglop>
	<20080707063522.5FE55154246@magilla.localdomain>
	<je8wwet9p6.fsf@sykes.suse.de>
	<20080707093151.8798A154246@magilla.localdomain>
X-Yow: I think my CAREER is RUINED!!
Date: Mon, 07 Jul 2008 12:01:14 +0200
In-Reply-To: <20080707093151.8798A154246@magilla.localdomain> (Roland
	McGrath's message of "Mon, 7 Jul 2008 02:31:51 -0700 (PDT)")
Message-ID: <je63rirp1x.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath <roland@redhat.com> writes:

> There are 32 bits free now.  One can anticipate that reassigning a bit
> would come up only after these are exhausted.  With prudent use, this
> will take a very long time to happen.  Then the oldest CPU type string
> might be retired to reuse its bit.  It seems unlikely that there will
> be a single installation (root directory) that really needs to have
> installed both a kernel optimized for the oldest CPU model known and a
> kernel optimized for the newest CPU model known.

The kernel does not have to come from the same place as the root
filesystem.  You may want to run a new kernel with an old filesystem, or
vice-versa.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
