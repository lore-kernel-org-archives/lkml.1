Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbZBEUph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbZBEUph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 15:45:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbZBEUp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 15:45:27 -0500
Received: from mail.candelatech.com ([208.74.158.172]:34976 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbZBEUp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 15:45:26 -0500
Message-ID: <498B4FD1.9000804@candelatech.com>
Date: Thu, 05 Feb 2009 12:45:05 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, len.brown@intel.com
Subject: Re: PATCH:  Allow over-ride of smp_found_cfg with kernel cmd-line
 option.
References: <498B421D.9090609@candelatech.com> <20090205195832.GD3129@elte.hu>
In-Reply-To: <20090205195832.GD3129@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> I'd _much_ rather have a warning message printed and have a default, 
> unconditional fallback to mptable parsing in this case.
> 
> I.e. same end result just no ugly and inconvenient force_smp_found_cfg.
> 
> The mptable works fine in most such cases to enumerate apic details. (as it 
> does in your case, evidently)
> 
> And if both the ACPI and the MPTABLE is hosed on a box, it cannot be of much 
> use on other OSs either, right?
> 
> So please do a patch that removes the 'smp_found_config' and which changes 
> the warning message to warn about no ACPI table in the MADT table. Ok?

That is fine with me, but I know next to zero about the deep logic
of this code.  I'd be worried that Len put in the change to fix something
more critical than my problem on my particular board.

If no one argues otherwise, I'll get a patch together & tested this evening.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

