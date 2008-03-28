Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbYC1Fwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbYC1Fwc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 01:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbYC1FwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 01:52:23 -0400
Received: from rtr.ca ([76.10.145.34]:2470 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184AbYC1FwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 01:52:22 -0400
Message-ID: <47EC8793.2040508@rtr.ca>
Date: Fri, 28 Mar 2008 01:52:19 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
Cc: jkosina@suse.cz, gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, pavel@suse.cz, akpm@linux-foundation.org
Subject: Re: 2.6.25-rc7: Ugh.
References: <20080327160700.GB828@suse.de>	<Pine.LNX.4.64.0803280126550.5541@jikos.suse.cz>	<47EC50A3.5070304@rtr.ca> <20080327.201202.163153963.davem@davemloft.net> <47EC8646.3050405@rtr.ca>
In-Reply-To: <47EC8646.3050405@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
>
> When I rebuilt with all debug stuff on, the kernel was worse than
> before, and just gave the "black screen of nothing" on resume,
> with a hung system.
> 
> At least before the system didn't hang.
> 
> Now I've just booted with a differently configured kernel,
> with only about half of the debug flags turned on.
> This one resumes from suspend, and *with* working USB too.
> 
> Ugh. Gotta love it when the bug is so subtle that turning on
> the debug flags makes it (1) get worse, and/or (2) get cured.
> 
> Here's the abbreviated diff between broken (no USB on resume, no hang),
> and working (good USB, no hang) .config files.
..
> -CONFIG_RTC_CLASS=y
> +# CONFIG_RTC_CLASS is not set

Mmm.. also had the RTC conflict resolved in that one.
Time to try another kernel with just the RTC change now.
