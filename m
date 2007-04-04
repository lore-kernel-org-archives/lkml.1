Return-Path: <linux-kernel-owner+w=401wt.eu-S1751044AbXDDUpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751044AbXDDUpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 16:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbXDDUpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 16:45:38 -0400
Received: from homer.mvista.com ([63.81.120.158]:14373 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbXDDUpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 16:45:38 -0400
Subject: Re: + clocksource-driver-initialize-list-value.patch added to -mm
	tree
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
       johnstul@us.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       heiko.carstens@de.ibm.com
In-Reply-To: <20070404203647.GA12563@elte.hu>
References: <200704010523.l315NXJP004063@shell0.pdx.osdl.net>
	 <1175417035.28263.42.camel@localhost.localdomain>
	 <1175704712.15973.35.camel@imap.mvista.com>
	 <20070404125853.1cf9b7b7.akpm@linux-foundation.org>
	 <1175717425.15973.61.camel@imap.mvista.com>
	 <20070404203647.GA12563@elte.hu>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 13:44:49 -0700
Message-Id: <1175719489.15973.66.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 22:36 +0200, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > The struct clocksource .list field is now required to be initialized 
> > before calling clocksource_register().
> > 
> > This is a prerequisite for simplifying the clocksource registration 
> > process.
> 
> why? This patch only pushes some unnecessary code into the clocksource 
> drivers:
> 
> +       .list           = LIST_HEAD_INIT(clocksource_avr32.list),
> 
> NACK unless you can give an explanation of why this is unavoidable. A 
> NULL initializer is just as good as an initialized list entry. (in fact 
> it's slightly better because it's in the kernel's BSS)

This is only 1 of 9 patches . The 9th patch requires the .list value to
be initialized .. The description change above was suppose to make that
clearer .. By forcing the .list value to be initialized we can simplify
the clocksource registration .

Daniel

