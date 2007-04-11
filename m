Return-Path: <linux-kernel-owner+w=401wt.eu-S1752596AbXDKNTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbXDKNTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 09:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbXDKNTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 09:19:49 -0400
Received: from mail.suse.de ([195.135.220.2]:43068 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbXDKNTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 09:19:49 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: eranian@hpl.hp.com
Subject: Re: 2.6.21-rc6-mm1
Date: Wed, 11 Apr 2007 15:19:43 +0200
User-Agent: KMail/1.9.6
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Adam Belay <abelay@novell.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, lenb@kernel.org
References: <653FFBB4508B9042B5D43DC9E18836F539ADFB@scsmsx415.amr.corp.intel.com> <200704111239.06259.ak@suse.de> <20070411130939.GA24875@frankl.hpl.hp.com>
In-Reply-To: <20070411130939.GA24875@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704111519.43738.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> So my point is that you cannot use the PMU to account for wall-clock time when you
> go in halted state. Yet, you could use the idle notifier to compensate for it by
> recording let's say TSC prior to entry and computing delta on exit. But then I am
> not sure what you would do with it given that other events may or may not have
> counted during that time, making scaling harder to do.

I think correcting it with the TSC is fine. It might not be perfect, but it's
good enough for most uses. Certainly much better than idle=poll

> Once solution, implemented by Itanium Montecito processor, is to have a PMU event
> that counts cycles spent in halted state. 

This solution is incompatible with aggressive power management.

-Andi
