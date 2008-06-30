Return-Path: <linux-kernel-owner+w=401wt.eu-S1759132AbYF3Qu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759132AbYF3Qu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 12:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbYF3Qup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 12:50:45 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:46478 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751800AbYF3Qun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 12:50:43 -0400
X-Sasl-enc: dEc8DcVmEuFR6juXG7P6uxE16H+0G9wtkxoVSUzUH8ao 1214844642
Date: Mon, 30 Jun 2008 13:50:37 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org,
       torvalds@osdl.org, akpm@osdl.org, acpi@linux.intel.com
Subject: Re: Temporary ACPI maintainer for this summer
Message-ID: <20080630165037.GA30779@khazad-dum.debian.net>
References: <871w2fujga.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871w2fujga.fsf@basil.nowhere.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008, Andi Kleen wrote:
> My main goal will be to merge patches from the usual contributors and
> try to keep the ACPI bugs and regressions under control. I don't plan
> many new features, but features already in progress will be processed
> as they are ready.
> 
> I'm also not full time working on ACPI, but also active in other areas.
> This means I will not write that many ACPI patches myself
> or do extensive testing on my own, but mostly focus on review and merging 
> and bug triage.
> 
> The git tree setup for the merges will be announced later.  I won't
> directly use Len's tree.

Andi,

Len usually stores all changes from different sub-maintainers in separate
topic branches, and as long as the tree had not been sent to Linus for
mainline merge yet, he would even let us resubmit patchsets (instead of
asking for incremental fixes):  he'd just drop the old topic branch with
that patchset, and create it anew using the new patchset.

Not every sub-maintainer took advantage of this, but some of us did.  It
would be nice to know beforehand how you're going to handle these issues
(i.e. do you prefer incremental fixing on stuff already staged for
submission, or a cleaned-up resubmission for re-staging?)

Also, as you should know, Len is the upstream path for some "platform
drivers" that are big ACPI users but not ACPI drivers in itself (mostly
laptop firmware drivers that live in drivers/misc).

These drivers have ties to subsystems spread all over the kernel (major ACPI
ties, but also leds, input, rfkill, gpio, hwmon...), so they often get
patches that require late merging (end of the merge window, early -rc1)
because of dependencies to subsystems outside ACPI.  Len was fine with it,
as long as the changes were local to the drivers (very low breakage risk for
anything else in the kernel).

> I'll take over all patches Len has already queued, so no need to
> resubmit them.  But if he doesn't have something acknowledged already
> you want to be included, please retransmit it to me.

You will get a bunch of thinkpad-acpi patches that depend upon net-next-2.6
soon...  I was waiting for some rfkill improvements to land on net-next-2.6
before submitting code that needs them.

That's something else I'd like to know.  Do you prefer to get such changes
[that depend on stuff still being submitted to other subsystems] early, or
only after their dependencies are already on a (mostly) assured path to
mainline?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
