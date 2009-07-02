Return-Path: <linux-kernel-owner+w=401wt.eu-S1752298AbZGBFry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbZGBFry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 01:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbZGBFrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 01:47:46 -0400
Received: from deleuze.hcoop.net ([69.90.123.67]:37036 "EHLO deleuze.hcoop.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbZGBFrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 01:47:46 -0400
From: Jeremy Maitin-Shepard <jeremy@jeremyms.com>
To: U Kuehn <ukuehn@acm.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, tuxonice-devel@lists.tuxonice.net,
       linux-kernel@vger.kernel.org
Subject: Re: [TuxOnIce-devel] RFC: Suspend-to-ram cold boot protection by encrypting page cache
References: <87hbxx0wcp.fsf@jeremyms.com> <200907011755.10386.rjw@sisk.pl>
	<874otw15r6.fsf@jeremyms.com> <200907020041.52198.rjw@sisk.pl>
	<87r5x0ypev.fsf@jeremyms.com> <4A4C4226.8000302@acm.org>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Wed, 01 Jul 2009 22:47:27 -0700
In-Reply-To: <4A4C4226.8000302@acm.org> (U. Kuehn's message of "Thu, 02 Jul
	2009 07:14:14 +0200")
Message-ID: <87ljn7y6ts.fsf@jeremyms.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

U Kuehn <ukuehn@acm.org> writes:

> [snip]

> The approach to encrypt the memory contents during suspend-to-ram seems
> to be a very fundamental change in the kernel, in order to protect
> against a very specific attack.

As I have said, I believe that tuxonice already supports almost
everything that is needed to implement it, and that the changes would
not in fact have to be all that intrusive to the rest of the kernel.

It is a very specific attack in some sense, but it is also a very
general attack in that it affects practically every computer out there.

> And unfortunately it helps only against an cold-boot attack that
> happens during suspend-to-ram. It does not protect against the attack
> taking place when the machine is just "on".

Naturally the protection is only effective when it is actually engaged.
However, I think that the cases in which a machine is susceptible to
being stolen or tampered often correspond to cases in which it makes
sense to have it suspended.  For a laptop, for instance, the highest
risk is likely when the machine is left unattended or in transit.  In
either case, it would likely be reasonable to have the machine
suspended.  Obviously the protection would not help you if you wish to
leave the machine unattended while it completes some computational task.

Nonetheless, I believe the level of protection offered would still be
very useful to many people, myself included.

-- 
Jeremy Maitin-Shepard
