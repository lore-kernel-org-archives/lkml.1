Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbYGGHuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbYGGHuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 03:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbYGGHuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 03:50:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbYGGHuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 03:50:01 -0400
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
X-Yow: Now I understand the meaning of ``THE MOD SQUAD''!
Date: Mon, 07 Jul 2008 09:49:57 +0200
In-Reply-To: <20080707063522.5FE55154246@magilla.localdomain> (Roland
	McGrath's message of "Sun, 6 Jul 2008 23:35:22 -0700 (PDT)")
Message-ID: <je8wwet9p6.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath <roland@redhat.com> writes:

>> I'm not sure... if ld.conf.d isn't parse of the kernel source tree then
>> it -will- end in tears...
>
> Of course, you should include the file you want people to install
> as part of the kernel source or build.  You can copy it into
> place in make install or something if you like (convention is to
> call it something.conf in /etc/ld.so.conf.d); then run ldconfig.

That will make it part of the kernel ABI, since the mapping depends on
the running kernel, doesn't it?

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
