Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbYH0GAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbYH0GAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 02:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbYH0F75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 01:59:57 -0400
Received: from smtp.nokia.com ([192.100.105.134]:35266 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbYH0F74 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 01:59:56 -0400
Subject: Re: [PATCH 2/2][MTD] Add support for > 2GiB MTD devices
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Bruce_Leonard@selinc.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-mtd-bounces@lists.infradead.org, linux-mtd@lists.infradead.org,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Bruce Leonard <brucle@earthlink.net>
In-Reply-To: <OF7C027ED9.D9F1F324-ON882574B2.0007025B-882574B2.000767B6@selinc.com>
References: <OF7C027ED9.D9F1F324-ON882574B2.0007025B-882574B2.000767B6@selinc.com>
Content-Type: text/plain; charset=utf-8
Date: Wed, 27 Aug 2008 08:56:37 +0300
Message-Id: <1219816597.18027.145.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 27 Aug 2008 05:59:41.0642 (UTC) FILETIME=[18DA3AA0:01C9080A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bruce,

On Tue, 2008-08-26 at 18:21 -0700, Bruce_Leonard@selinc.com wrote:
> > This changes the kernel<->userspace ABI and is hence a big no-no.  I
> > assume that this change will cause old userspace to malfunction on new
> > kernels, and vice versa.
> > 
> 
> Well, in my posting I noted that the mtd-utils were broken because of this 
> but I didn't really have any idea as to how to fix things.  I can see why 
> it would be a big no-no to change this.  Do you have any suggestions on 
> what I could do differently to prevent making that change?

Unfortunately, it is unacceptable to break existing stuff, even old
crappy mtd utils :-). That's simply how we work in the kernel community.

Stuff which you do is always not simple because you have to make sure
all legacy stuff does not break. So you'll need to invest more time into
your work.

> There was a LOT of interest in this over the last few months while I was 
> working on it, but a very suprising silence has developed since I posted 
> the patches.  I guess I'm more cutting edge than I thought :).

I understand your frustration. Apologies for not reacting faster.

> > Please cc linux-mtd@lists.infradead.org (at least) on MTD-related
> > patches, thanks.
> 
> I started with the MTD list and then also posted to lkml when I realized I 
> had forgotten to CC it.

Yeah, sometimes MTD ML just ignores patches, I am in the same boat, but
even if you've decided to send stuff to lkml, please, CC MTD ML anyway.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

