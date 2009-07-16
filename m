Return-Path: <linux-kernel-owner+w=401wt.eu-S1753630AbZGPIaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbZGPIaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 04:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbZGPI37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 04:29:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:52102 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbZGPI36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 04:29:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,410,1243839600"; 
   d="scan'208";a="430699343"
Subject: Re: [PATCH 0/8] device async action mechanism
From: Zhang Rui <rui.zhang@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
In-Reply-To: <20090716080731.GB8046@one.firstfloor.org>
References: <1247643512.26272.74.camel@rzhang-dt>
	 <87ocrm6xeq.fsf@basil.nowhere.org> <1247710483.26272.170.camel@rzhang-dt>
	 <20090716080731.GB8046@one.firstfloor.org>
Content-Type: text/plain; charset=utf-8
Date: Thu, 16 Jul 2009 16:30:47 +0800
Message-Id: <1247733047.26272.199.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 16:07 +0800, Andi Kleen wrote:
> On Thu, Jul 16, 2009 at 10:14:43AM +0800, Zhang Rui wrote:
> > On Wed, 2009-07-15 at 18:41 +0800, Andi Kleen wrote:
> > > Zhang Rui <rui.zhang@intel.com> writes:
> > > >
> > > > Currently, in order to make sure that it won't bring any side effects,
> > > > I only convert the ACPI battery and i8042 to use this framework, which reduces
> > > > 0.5s+ S3 time(suspend time plus resume time)ï»¿, from 7.0s to less than 6.5s.

> > > 
> > > 10.5s+ was intended I guess?
> > > 
> > what do you mean?
> 
> I am confused by you writing
> 
> "reduces <small number> from <much larger number> to <still larger number>"
> 
> So I assumed you dropped a decimal on <small number>
> 
sorry for my poor English.

I mean the total S3 time (including kernel suspend and kernel resume)
reduces more than 0.5 second.
it takes 7.0s without this patch set and now it takes only 6.5s.

thanks,
rui

