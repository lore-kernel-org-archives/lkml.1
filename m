Return-Path: <linux-kernel-owner+w=401wt.eu-S1763217AbYF3RY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763217AbYF3RY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 13:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756383AbYF3RX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 13:23:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53637 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382AbYF3RX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 13:23:57 -0400
Message-ID: <486916A9.8050808@firstfloor.org>
Date: Mon, 30 Jun 2008 19:23:53 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org,
       torvalds@osdl.org, akpm@osdl.org, acpi@linux.intel.com
Subject: Re: Temporary ACPI maintainer for this summer
References: <871w2fujga.fsf@basil.nowhere.org> <20080630165037.GA30779@khazad-dum.debian.net>
In-Reply-To: <20080630165037.GA30779@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Len usually stores all changes from different sub-maintainers in separate
> topic branches, and as long as the tree had not been sent to Linus for
> mainline merge yet, he would even let us resubmit patchsets (instead of
> asking for incremental fixes):  he'd just drop the old topic branch with
> that patchset, and create it anew using the new patchset.

I don't plan to use topic branches, but have a quilt/guilt workflow
that makes it possible to drop patches.

> Not every sub-maintainer took advantage of this, but some of us did.  It
> would be nice to know beforehand how you're going to handle these issues
> (i.e. do you prefer incremental fixing on stuff already staged for
> submission, or a cleaned-up resubmission for re-staging?)

I prefer cleaned-up resubmission in general over incremental changes.
I would just merge the incrementals into the original patches anyways,
so the submitter does that it is best.


> These drivers have ties to subsystems spread all over the kernel (major ACPI
> ties, but also leds, input, rfkill, gpio, hwmon...), so they often get
> patches that require late merging (end of the merge window, early -rc1)
> because of dependencies to subsystems outside ACPI.  Len was fine with it,
> as long as the changes were local to the drivers (very low breakage risk for
> anything else in the kernel).

Ok. We'll need to talk about that in detail.

>> I'll take over all patches Len has already queued, so no need to
>> resubmit them.  But if he doesn't have something acknowledged already
>> you want to be included, please retransmit it to me.
> 
> You will get a bunch of thinkpad-acpi patches that depend upon net-next-2.6
> soon...  I was waiting for some rfkill improvements to land on net-next-2.6
> before submitting code that needs them.
> 
> That's something else I'd like to know.  Do you prefer to get such changes
> [that depend on stuff still being submitted to other subsystems] early, or
> only after their dependencies are already on a (mostly) assured path to
> mainline?

Earlier. The tree would be based on linux-next.

-Andi

