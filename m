Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbYFXR4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbYFXR4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 13:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbYFXRzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 13:55:48 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:36153 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbYFXRzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 13:55:47 -0400
Date: Tue, 24 Jun 2008 19:55:44 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "akinobu.mita@gmail.com" <akinobu.mita@gmail.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH 3/14] arch/ia64: Eliminate NULL test and memset after
 alloc_bootmem
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3062D2438@orsmsx505.amr.corp.intel.com>
Message-ID: <Pine.LNX.4.64.0806241948120.26777@ask.diku.dk>
References: <Pine.LNX.4.64.0806241021360.26777@ask.diku.dk>
 <57C9024A16AD2D4C97DC78E552063EA3062D2438@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2008, Luck, Tony wrote:

> > As noted by Akinobu Mita in patch b1fceac2b9e04d278316b2faddf276015fc06e3b,
> > alloc_bootmem and related functions never return NULL and always return a
> > zeroed region of memory.  Thus a NULL test or memset after calls to these
> > functions is unnecessary.
> 
> There is no commit b1fceac2b9e04d278316b2faddf276015fc06e3b in Linus' tree.

I am not sure to know how to tell precisely where you are looking, but you 
can find it here:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b1fceac2b9e04d278316b2faddf276015fc06e3b


> In addition the current alloc_bootmem() is a macro that uses __alloc_bootmem
> which most defintely can return NULL.

The "return NULL;" at the bottom of __alloc_bootmem is preceded by 
panic("Out of memory");, which I assume cannot return?

> Is this against -mm or linux-next?

I pull files from the following git repository:

git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

julia

