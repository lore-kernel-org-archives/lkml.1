Return-Path: <linux-kernel-owner+w=401wt.eu-S934617AbXGKX1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934617AbXGKX1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765496AbXGKX1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:27:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32805 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763769AbXGKX1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:27:45 -0400
From: Andreas Schwab <schwab@suse.de>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jason Wessel <jason.wessel@windriver.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] Pass -g to assembler under CONFIG_DEBUG_INFO
References: <20070711231929.579334D0555@magilla.localdomain>
X-Yow: WHOA!!  Ken and Barbie are having TOO MUCH FUN!!  It must
 be the NEGATIVE IONS!!
Date: Thu, 12 Jul 2007 01:27:35 +0200
In-Reply-To: <20070711231929.579334D0555@magilla.localdomain> (Roland
	McGrath's message of "Wed\, 11 Jul 2007 16\:19\:29 -0700 \(PDT\)")
Message-ID: <jelkdmjzbs.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath <roland@redhat.com> writes:

>> > +AFLAGS		+= $(call as-option, -gdwarf)
>> 
>> The option is officially called -gdwarf-2, and -gdwarf2 is an alias for
>> backward compatibility.  But -gdwarf is ambigous and will error out.
>
> AFLAGS is actually passed to $(CC), not $(AS), and -gdwarf works there
> (it's an unambiguous prefix of -gdwarf-2).

Oh yes, you're right, sorry for the noise.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
