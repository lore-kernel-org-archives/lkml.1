Return-Path: <linux-kernel-owner+w=401wt.eu-S936769AbXG0Jyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936769AbXG0Jyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 05:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936463AbXG0JvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 05:51:00 -0400
Received: from ns2.suse.de ([195.135.220.15]:35538 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937007AbXG0Ju7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 05:50:59 -0400
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, lguest <lguest@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix lguest bzImage loading with CONFIG_RELOCATABLE=y
References: <1185507343.12151.25.camel@localhost.localdomain>
From: Andi Kleen <andi@firstfloor.org>
Date: 27 Jul 2007 12:45:43 +0200
In-Reply-To: <1185507343.12151.25.camel@localhost.localdomain>
Message-ID: <p73wswmqg4o.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> writes:

> Jason Yeh sent his crashing .config: bzImages made with
> CONFIG_RELOCATABLE=y put the relocs where the BSS is expected, and we
> crash with unusual results such as:

The normal kernel startup should already clear BSS. Why does
this not work here? Can it be fixed?

-Andi
