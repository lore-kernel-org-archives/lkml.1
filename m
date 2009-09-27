Return-Path: <linux-kernel-owner+w=401wt.eu-S1753539AbZI0I37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbZI0I37 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 04:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbZI0I35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 04:29:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:44739 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521AbZI0I3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 04:29:55 -0400
Message-ID: <4ABF2262.3090905@kernel.org>
Date: Sun, 27 Sep 2009 01:29:22 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: add show_lapic=
References: <4ABF0DE0.1030400@kernel.org> <20090927080605.GA4984@lenovo>
In-Reply-To: <20090927080605.GA4984@lenovo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> [Yinghai Lu - Sun, Sep 27, 2009 at 12:01:52AM -0700]
> | 
> | so could use that together with apci=debug to print less cpu apic.
> | 
> | otherwise for system have more cpus will take a while
> | 
> | also move apic_verbosity check to print_all_ICs
> | 
> | Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> | 
> | ---
> |  arch/x86/kernel/apic/io_apic.c |   42 ++++++++++++++++++++++++++---------------
> |  1 file changed, 27 insertions(+), 15 deletions(-)
> ...
> 
> Hi Yinghai, good idea!
> 
> I've tuned your patch a bit together with changelog.
> 
> 1) show_lapic=1 by default does change current kernel behaviour
>    so it should be set to max cpu available.

think about system with lots of cpu. but i still want to use apic=debug

> 2) show_lapic contains the max number of lapics being printed
>    so we need to count them instead of plain comparation with
>    cpu number, as a result I've changed print_local_APICs. Or
>    you meant _exactly_ cpuid number? In meaning like
>    show_lapic=max_cpuid. Hmm?
> 
your change anything about that. there is not gap between cpu id.

YH
