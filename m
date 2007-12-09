Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbXLIBIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbXLIBIZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 20:08:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbXLIBIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 20:08:16 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38149 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbXLIBIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 20:08:15 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, "Huang, Ying" <ying.huang@intel.com>,
       nigel@nigel.suspend2.net, Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH 1/4 -mm] kexec based hibernation -v7 : kexec jump
References: <1197042810.24045.61.camel@caritas-dev.intel.com>
	<20071208235344.GA17005@elf.ucw.cz> <200712090119.57826.rjw@sisk.pl>
Date: Sat, 08 Dec 2007 18:06:02 -0700
In-Reply-To: <200712090119.57826.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Sun, 9 Dec 2007 01:19:56 +0100")
Message-ID: <m1prxgoex1.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

>> I'm not kexec hacker... but maybe this is in good enough state to be
>> merged? It is useful on its own: kexec jump and back means we can dump
>> system then continue running, for example...
>
> As far as I'm concerned, patches [1/4] and [2/4] can go.
>
> The other two are not in that shape yet (especially the [3/4] patch).

Ok.  Then I will see if I can review these in the next couple days
and give some feedback.

At a quick skim through the code it appears there is some more infrastructure
then we need and things can still be simplified.

Since this applies in particular to the user space interface I'm not comfortable
with these patches going in just yet.

The unused KEXEC_PRESERVE_ flags especially give me pause.  Having something
like that, that isn't currently wired up sounds like a bad place to start.

Eric
