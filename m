Return-Path: <linux-kernel-owner+w=401wt.eu-S1757139AbZGPCOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139AbZGPCOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 22:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757123AbZGPCOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 22:14:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:52393 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757074AbZGPCOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 22:14:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,408,1243839600"; 
   d="scan'208";a="533240196"
Subject: Re: [PATCH 0/8] device async action mechanism
From: Zhang Rui <rui.zhang@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       arjan@linux.intel.com, "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
In-Reply-To: <87ocrm6xeq.fsf@basil.nowhere.org>
References: <1247643512.26272.74.camel@rzhang-dt>
	 <87ocrm6xeq.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 16 Jul 2009 10:14:43 +0800
Message-Id: <1247710483.26272.170.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-15 at 18:41 +0800, Andi Kleen wrote:
> Zhang Rui <rui.zhang@intel.com> writes:
> >
> > Currently, in order to make sure that it won't bring any side effects,
> > I only convert the ACPI battery and i8042 to use this framework, which reduces
> > 0.5s+ S3 time(suspend time plus resume time)ï»¿, from 7.0s to less than 6.5s.
> 
> 10.5s+ was intended I guess?
> 
what do you mean?

the kernel device suspend time is reduced from 3.2s to 2.8s after
applying this patch set in my test box.
And I get more optimistic numbers on another laptop, an Eeepc 901,
from about 2s to 1.6s. And the shutdown time is also reduced 0.4s.

thanks,
rui



