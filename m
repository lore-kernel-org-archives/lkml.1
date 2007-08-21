Return-Path: <linux-kernel-owner+w=401wt.eu-S1762542AbXHURv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762542AbXHURv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 13:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761528AbXHURvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 13:51:51 -0400
Received: from mail.suse.de ([195.135.220.2]:49438 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761417AbXHURvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 13:51:50 -0400
Date: Tue, 21 Aug 2007 20:45:43 +0200
From: Andi Kleen <ak@suse.de>
To: Daniel Walker <dwalker@mvista.com>
Cc: Andi Kleen <ak@suse.de>, patches@x86-64.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [12/58] x86_64: Add vDSO for x86-64 with gettimeofday/clock_gettime/getcpu
Message-ID: <20070821184543.GK32640@bingen.suse.de>
References: <200707191154.642492000@suse.de> <20070719095456.B996214E03@wotan.suse.de> <1187713502.7732.65.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187713502.7732.65.camel@imap.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> In the -mm kernel there is some debugging that gets injected into the
> likely/unlikely macros .. If they get called from userspace it causes a

They should likely define a __likely()/__unlikely() then that doesn't
do this.

> hang .. We might want to add some new set of macros to specifically
> denote that they are called from userspace, not just likely/unlikely but
> all the macros so we don't get mixed usage ..

and add a hunk to change the vDSO code. Note that i386 is not the 
only architecture that has such code.

-Andi
