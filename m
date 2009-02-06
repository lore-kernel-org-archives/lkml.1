Return-Path: <linux-kernel-owner+w=401wt.eu-S1759349AbZBFRwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349AbZBFRwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 12:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbZBFRwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 12:52:24 -0500
Received: from mail.candelatech.com ([208.74.158.172]:55597 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbZBFRwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 12:52:24 -0500
Message-ID: <498C78C9.5090405@candelatech.com>
Date: Fri, 06 Feb 2009 09:52:09 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel <linux-kernel@vger.kernel.org>, rusty@rustcorp.com.au
Subject: Re: PATCH:  Allow user to force 'tsc' to be treated as stable.
References: <498B42C5.7010905@candelatech.com> <alpine.LRH.1.10.0902061531560.22097@twin.jikos.cz>
In-Reply-To: <alpine.LRH.1.10.0902061531560.22097@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Thu, 5 Feb 2009, Ben Greear wrote:
> 
>> Allow user to force TSC as stable clock-source. Works around BIOS issues 
>> in the FWA-7304 (Via CN700 chipset) system, and possibly others.
> 
> How do you know that the TSC is stable on such system? What was the reason 
> for kernel marking it unstable?

I've used it for a timing source in my own modules and it has
worked well.  It could still be broken in some way, but if so,
I'm not sure how to detect it.  Ingo sent me a program to test
the tsc, and at least for short runs, it showed no problem.

Another person suggested the system might think it is unstable
because I have ACPI disabled in my BIOS and that might cause
the kernel not to have a 'PM timer' that it uses to check the
tsc?

Other than that, I have no idea why the kernel thinks the tsc
is unstable.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

