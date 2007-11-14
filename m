Return-Path: <linux-kernel-owner+w=401wt.eu-S1763732AbXKNS7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763732AbXKNS7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 13:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763326AbXKNS6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 13:58:42 -0500
Received: from smtp25.orange.fr ([193.252.22.21]:33499 "EHLO smtp25.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761761AbXKNS6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 13:58:40 -0500
X-ME-UUID: 20071114185835973.EDB131C00086@mwinf2531.orange.fr
Date: Wed, 14 Nov 2007 19:53:40 +0100
From: Philippe Elie <phil.el@wanadoo.fr>
To: William Cohen <wcohen@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Stephane Eranian <eranian@hpl.hp.com>,
       akpm@osdl.org, Robert Richter <robert.richter@amd.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Message-ID: <20071114185340.GB2894@zaniah>
References: <20071113212902.GA17593@one.firstfloor.org> <20071113214628.GE5747@frankl.hpl.hp.com> <20071113215056.GB17593@one.firstfloor.org> <20071113222234.GH5747@frankl.hpl.hp.com> <20071113222534.GC17145@one.firstfloor.org> <20071113225848.GK5747@frankl.hpl.hp.com> <20071114020702.GB20365@one.firstfloor.org> <20071114130909.GB6557@frankl.hpl.hp.com> <20071114142411.GD17145@one.firstfloor.org> <473B17D4.5050702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473B17D4.5050702@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007 at 10:44 +0000, Will Cohen wrote:

> Andi Kleen wrote:
> 
> >>One approach does not prevent the other. Assuming you allow cr4.pce, then 
> >>nothing prevents
> >>a self-monitoring thread from reading the counters directly. You'll just 
> >>get the
> >>lower 32-bit of it. So if you read frequently enough, you should not have 
> >>a problem.
> >
> >Hmm? RDPMC is 64bit.
> 
> There are a number of processors that have 32-bit counters such as the IBM 
> power processors. On many x86 processors the upper bits of the counter are 
> sign extended from the lower 32 bits. Thus, one can only assume the lower 
> 32-bit are available. Roll over of values is quite possible (<2 seconds of 
> cycle count), so additional work needs to be done to obtain a valid value.

On x86 they are sign-extended only on write, on read they are 40 bits wide
for intel, 48 bits for AMD.

BTW, isn't rdpmc only enable for ring 0 on linux ? I remember a patch
to disable it, dunno if it has been applied.

-- 
Phe

