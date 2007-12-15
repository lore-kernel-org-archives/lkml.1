Return-Path: <linux-kernel-owner+w=401wt.eu-S1760841AbXLOSXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760841AbXLOSXO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 13:23:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755587AbXLOSXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 13:23:04 -0500
Received: from mga06.intel.com ([134.134.136.21]:21336 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755404AbXLOSXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 13:23:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,172,1196668800"; 
   d="scan'208";a="242149497"
Message-ID: <47641B0F.3040709@linux.intel.com>
Date: Sat, 15 Dec 2007 10:21:03 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       protasnb@gmail.com
Subject: Re: Top kernel oopses/warnings this week
References: <4762CF8C.90808@linux.intel.com> <4763F771.10105@s5r6.in-berlin.de>
In-Reply-To: <4763F771.10105@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Arjan van de Ven wrote:
>> The http://www.kerneloops.org website collects kernel oops and warning
>> reports from various mailing lists and bugzillas;
> 
> A few comments:
> 
> Report counts may be too high due to duplicate recognition of the very
> same report.¹

this is true however it's .. a hard issue. It's really hard to distinguish a duplicate report from
two reports of the same bug.

> 
> Reports against 2.6.X-rcY-mmZ are listed in the same category as reports
> against 2.6.X-rcY.  To distinguish -mm reports from vanilla reports, one
> has to look into the details of each bug entry.¹

finding what exact kernel version an oops is from is... surprisingly hard.
And to be honest, bugs against -mm are still very interesting, since they'll be
the next mainline after all

> 
> A general weakness is that it is ultimately impossible to know whether a
> report was against an unpatched kernel, unless one drills down to the
> individual mailinglist threads.

for the same reason patched kernels are relevant. And if someone has a super weirdo kernel,
well, as long as we get enough bug data it'll be way down in the noise.


> Reports about tainted kernels have arguably less value.  It would be
> good to hide such reports until a report of the same oops in an
> untainted kernel was found.
That's half of what is done right now; they're not hidden though, just very clearly marked.
