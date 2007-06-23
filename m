Return-Path: <linux-kernel-owner+w=401wt.eu-S1760984AbXFWQxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760984AbXFWQxH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 12:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760197AbXFWQwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 12:52:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56406 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760184AbXFWQwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 12:52:54 -0400
Date: Sat, 23 Jun 2007 09:52:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wang Zhenyu <zhenyu.z.wang@intel.com>
Cc: davej@redhat.com, carlo@alinoe.com, linux-kernel@vger.kernel.org,
       eric@anholt.net
Subject: Re: [PATCH][AGPGART] intel_agp: don't load if no IGD and AGP port
Message-Id: <20070623095203.66bb8572.akpm@linux-foundation.org>
In-Reply-To: <20070621054318.GA31381@zhen-devel.sh.intel.com>
References: <alpine.LFD.0.98.0706181127380.14121@woody.linux-foundation.org>
	<20070618195415.GA7481@alinoe.com>
	<alpine.LFD.0.98.0706181332400.3593@woody.linux-foundation.org>
	<20070618225009.GE13538@alinoe.com>
	<alpine.LFD.0.98.0706181553450.3593@woody.linux-foundation.org>
	<20070619233716.GA5779@alinoe.com>
	<20070620011521.GB2856@zhen-devel.sh.intel.com>
	<20070620014227.GA4090@zhen-devel.sh.intel.com>
	<20070620140237.GB5524@alinoe.com>
	<20070620154610.GA2802@localhost.localdomain>
	<20070621054318.GA31381@zhen-devel.sh.intel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 21 Jun 2007 13:43:18 +0800 Wang Zhenyu <zhenyu.z.wang@intel.com> wrote:
> Thanks Carlo to report this problem. The following patch should fix
> his and potential issue.
> 
> [AGPGART] intel_agp: don't load if no IGD detected and no AGP port
> 
> After i915 chip, GMCH has no AGP port. Origin bridge driver in device
> table will try to access illegal regs like APBASE, APSIZE, etc. This
> may cause problem.
> 
> So mark them as NULL in the table, we won't load if no IGD got detect
> and bridge has no AGP port.

Looking at the above, I have no way of telling what the actual bug is, nor
have I any way of telling what the consequences would be of not having this
patch in 2.6.22.  Nor can I tell whether we want it in 2.6.21.x.

I probably _could_ work this out, and kinda did with a bit of list-trolling
(verdict: needed in 2.6.22) but please, take care to describe the
importance of a patch in the changelog?

Thanks.
