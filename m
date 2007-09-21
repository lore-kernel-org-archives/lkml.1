Return-Path: <linux-kernel-owner+w=401wt.eu-S1751971AbXIUEth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbXIUEth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 00:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbXIUEta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 00:49:30 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:60446 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbXIUEt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 00:49:29 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: nigel@suspend2.net
Cc: "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
References: <1190266447.21818.17.camel@caritas-dev.intel.com>
	<200709211225.25874.nigel@nigel.suspend2.net>
	<1190342757.21818.75.camel@caritas-dev.intel.com>
	<200709211259.00195.nigel@nigel.suspend2.net>
Date: Thu, 20 Sep 2007 22:46:08 -0600
In-Reply-To: <200709211259.00195.nigel@nigel.suspend2.net> (Nigel Cunningham's
	message of "Fri, 21 Sep 2007 12:58:59 +1000")
Message-ID: <m1r6ksiq27.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nigel Cunningham <nigel@nigel.suspend2.net> writes:
>
> Sounds doable, as long as you can cope with long command lines (which 
> shouldn't be a biggie). (If you've got a swapfile or parts of a swap 
> partition already in use, it can be quite fragmented).

Hmm.  This is an interesting problem.  Sharing a swap file or a swap
partition with the actual swap of user space pages does seem to be
a limitation of this approach.

Although the fact that it is simple to write to a separate file may
be a reasonable compensation.

> Andrew, you're seeing that it really doesn't mean the removal of all 
> hibernation code from the kernel being suspended, aren't you? (And if the 
> kexec'd kernel is the same binary, then there's more code again).

More binary size yes not more code to maintain.

As for the rest the current implementation is small enough and allows
for enough beyond hibernation I think it makes sense to eventually
merge assuming a good clean implementation can be achieved.

Eric
