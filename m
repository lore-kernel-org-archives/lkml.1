Return-Path: <linux-kernel-owner+w=401wt.eu-S1032151AbXEHVCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032151AbXEHVCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032145AbXEHVCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:02:43 -0400
Received: from lazybastard.de ([212.112.238.170]:39834 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031630AbXEHVCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:02:42 -0400
Date: Tue, 8 May 2007 22:58:27 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/2] LogFS proper
Message-ID: <20070508205827.GC23056@lazybastard.org>
References: <20070507215913.GA15054@lazybastard.org> <20070507220036.GB15054@lazybastard.org> <1178608950.3042.273.camel@localhost.localdomain> <20070508163226.GA22443@lazybastard.org> <84144f020705081215t73f2c0fq8ecb677423329cd8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84144f020705081215t73f2c0fq8ecb677423329cd8@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 22:15:18 +0300, Pekka Enberg wrote:
> On 5/8/07, Jörn Engel <joern@lazybastard.org> wrote:
> >> > +typedef __be16 be16;
> >> > +typedef __be32 be32;
> >> > +typedef __be64 be64;
> >>
> >> Why are those typedefs necessary ?
> >
> >Not strictly.  I tend to use the be* types fairly often in the code and
> >simply grew weary of seeing the underscores.
> >
> >Any objections if I seperate out the userspace headers and keep the
> >shorthands for kernel code only?
> 
> Not sure what you mean but I would prefer you drop the typedefs completely.

Basically I prefer be64 over __be64 for similar reasons that most people
prefer u64 over __u64.  Others prefer uint64_t over both, but C99 hasn't
defined beint64_t yet.

Maybe I should secretly patch include/linux/types.h to add these three
lines and bribe akpm's evil twin to merge that?  It definitely makes
more sense to have such a typedef in generic code or not at all.

Jörn

-- 
Audacity augments courage; hesitation, fear.
-- Publilius Syrus
