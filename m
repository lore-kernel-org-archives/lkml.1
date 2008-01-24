Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbYAXOnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbYAXOnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 09:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbYAXOnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 09:43:04 -0500
Received: from rtr.ca ([76.10.145.34]:2118 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbYAXOnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 09:43:01 -0500
Message-ID: <4798A3F4.1070302@rtr.ca>
Date: Thu, 24 Jan 2008 09:43:00 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: yi.y.yang@intel.com
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org,
       acpi-bugzilla@lists.sourceforge.net
Subject: Re: [PATCH] ACPI: create proc entry 'power' only if C2 or C3 is	supported
References: <1198738022.8950.3.camel@yangyi-dev.bj.intel.com>	 <1198744900.3640.4.camel@yangyi-dev.bj.intel.com>	 <1198916553.3806.2.camel@yangyi-dev.bj.intel.com>	 <1199434602.19185.1.camel@yangyi-dev.bj.intel.com>	 <1199688961.3551.19.camel@yangyi-dev.bj.intel.com>	 <1199762486.3551.22.camel@yangyi-dev.bj.intel.com> <1201135532.3969.3.camel@yangyi-dev.bj.intel.com>
In-Reply-To: <1201135532.3969.3.camel@yangyi-dev.bj.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: ACPI: Create proc entry 'power' only C2 or C3 is supported
> From: Yi Yang <yi.y.yang@intel.com>
> 
> ACPI processor idle driver makes sense only if the processor supports
> C2 or C3. For legacy C0 and C1, just the original pm_idle is working
> , statistics info about promotion, demotion, latency, usage and
> duration are empty or 0, so these are misleading, users'll think their
> CPUs support C states (C2 or C3), /proc/acpi/processor/CPU*/power
> shouldn't exist for this case at all.
..

On the other hand, this change might send many of us scrambling
to try and figure out which kernel CONFIG option is responsible
for the expected /proc/acpi/processor/CPU*/power entries not showing up.
Thus just adding to the confusion by as much as it saves.

What do others think?


