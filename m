Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbZGPIHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbZGPIHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 04:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbZGPIHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 04:07:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60245 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbZGPIHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 04:07:34 -0400
Date: Thu, 16 Jul 2009 10:07:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       arjan@linux.intel.com, "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
Subject: Re: [PATCH 0/8] device async action mechanism
Message-ID: <20090716080731.GB8046@one.firstfloor.org>
References: <1247643512.26272.74.camel@rzhang-dt> <87ocrm6xeq.fsf@basil.nowhere.org> <1247710483.26272.170.camel@rzhang-dt>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1247710483.26272.170.camel@rzhang-dt>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 10:14:43AM +0800, Zhang Rui wrote:
> On Wed, 2009-07-15 at 18:41 +0800, Andi Kleen wrote:
> > Zhang Rui <rui.zhang@intel.com> writes:
> > >
> > > Currently, in order to make sure that it won't bring any side effects,
> > > I only convert the ACPI battery and i8042 to use this framework, which reduces
> > > 0.5s+ S3 time(suspend time plus resume time)﻿, from 7.0s to less than 6.5s.
> > 
> > 10.5s+ was intended I guess?
> > 
> what do you mean?

I am confused by you writing

"reduces <small number> from <much larger number> to <still larger number>"

So I assumed you dropped a decimal on <small number>


> 
> the kernel device suspend time is reduced from 3.2s to 2.8s after
> applying this patch set in my test box.
> And I get more optimistic numbers on another laptop, an Eeepc 901,
> from about 2s to 1.6s. And the shutdown time is also reduced 0.4s.


I think I am still confused by your numbers.

How do the 0.5s and the 7.0s relate?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
