Return-Path: <linux-kernel-owner+w=401wt.eu-S1763572AbYETNrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763572AbYETNrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 09:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472AbYETNrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 09:47:40 -0400
Received: from gw.goop.org ([64.81.55.164]:39570 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159AbYETNrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 09:47:40 -0400
Message-ID: <4832D65C.2030108@goop.org>
Date: Tue, 20 May 2008 14:47:08 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Gabriel C <nix.or.die@googlemail.com>,
       Keith Packard <keithp@keithp.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Eric Anholt <eric@anholt.net>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, airlied@linux.ie,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 0 of 8] x86: use PTE_MASK consistently
References: <patchbomb.1211268376@localhost> <Pine.LNX.4.64.0805201346120.24102@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0805201346120.24102@blonde.site>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> I'll leave it to you and Linus whether your way of defining PTE_MASK is
> satisfactory as is, or needs to be improved to his way.  I've not tried
> his suggestion of doing the _PAGE_BIT definitions: certainly it's
> seemed odd to me that they were defined with L, but I've little
> appetite to mess around with them now myself.
>   

Yes, well, that was me too, with the intention of making ~_PAGE_FOO 
generate an appropriately sized mask.  I guess it would be better to use 
pteval_t these days.

    J
