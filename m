Return-Path: <linux-kernel-owner+w=401wt.eu-S1755581AbYATSwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbYATSwT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 13:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754147AbYATSwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 13:52:12 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38415 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbYATSwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 13:52:11 -0500
Date: Sun, 20 Jan 2008 19:55:41 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ian Campbell <ijc@hellion.org.uk>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native format.
Message-ID: <20080120185541.GA28024@one.firstfloor.org>
References: <1200758937-22386-1-git-send-email-ijc@hellion.org.uk> <1200758937-22386-2-git-send-email-ijc@hellion.org.uk> <87prvxct42.fsf@basil.nowhere.org> <1200847490.26633.62.camel@cthulhu.hellion.org.uk> <20080120173938.GA27247@one.firstfloor.org> <47939787.3050707@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47939787.3050707@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >There are various loaders (kexec, elilo, ...) that skip the 16bit code
> >and jump directly to 32bit head.S. So in theory those could hit it.
> >But still having the loop only is probably fine.
> >
> 
> It's probably just as well, since we don't really know how to get a 
> message out in such an environment anyway...

It would be robably possible to extend the 32bit protocol to some
way to error out in such a case. On the other hand I'm not sure it's really
worth the considerable work to implement and debug such an addition.

> >>variant of make_pte now though.
> >
> >The 32bit cast still feels unclean. After all the PTE is not 32bit.
> 
> No, but (pte_t *) is 32 bits.  To be more "Linuxy" it probably should be 
> (long) or (unsigned long) though.

That's not 32bit either.

-Andi
