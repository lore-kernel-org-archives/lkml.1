Return-Path: <linux-kernel-owner+w=401wt.eu-S1761947AbXFJWql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761947AbXFJWql (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 18:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932121AbXFJWqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 18:46:31 -0400
Received: from rtr.ca ([64.26.128.89]:1250 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932111AbXFJWqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 18:46:30 -0400
Message-ID: <466C7F44.1040309@rtr.ca>
Date: Sun, 10 Jun 2007 18:46:28 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch-mm 00/23] High resolution timer updates and x86_64 support
References: <20070610092437.118387863@inhelltoy.tec.linutronix.de>
In-Reply-To: <20070610092437.118387863@inhelltoy.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> The following patch series contains:
> 
> - dyntick bugfixes for -mm (caused by the cpuidle changes in ACPI)
> 
> - updates and improvements to high resolution timer / dynticks 
> 
> - high resolution timer / dynticks support for x86_64
> 
> The x86_64 support is based on an initial patch from Chris Wright. Thanks Chris !
> 
> The patch set has been tested in the -hrt and -rt trees for quite a while
> and the initial problems have been sorted out. Thanks to the folks from the
> PowerTop project for testing and feedback.
> 
> The -hrt tree at http://www.tglx.de/projects/hrtimers/2.6.22-rc4/ contains
> also an hpet force patch series from Venki Pallipadi, but I leave this up to
> Venki to send it mainline wards.

Do you know if there's anything specific in there that would fix
the start-up race condition with HRTIMERS on my machine here
(previously discussed, yet unresolved)?

It still happens sporadically on boot-up -- maybe one in 10 boots without
any change in the kernel binary..

Cheers
