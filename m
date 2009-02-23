Return-Path: <linux-kernel-owner+w=401wt.eu-S1755055AbZBWUwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbZBWUwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 15:52:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbZBWUwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 15:52:39 -0500
Received: from gate.crashing.org ([63.228.1.57]:57575 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbZBWUwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 15:52:38 -0500
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during
 suspend-resume
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Johannes Berg <johannes@sipsolutions.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20090223122832.GB31427@elte.hu>
References: <200902221837.49396.rjw@sisk.pl>
	 <200902230048.33635.rjw@sisk.pl> <20090223083645.GA9582@elte.hu>
	 <200902231229.58743.rjw@sisk.pl>  <20090223122832.GB31427@elte.hu>
Content-Type: text/plain
Date: Tue, 24 Feb 2009 07:49:21 +1100
Message-Id: <1235422161.8805.241.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> That property can be implied in the function name:
> 
>    	device_power_down_irq_disable(PMSG_SUSPEND);
> 
> Open-coding it, if it looks the same in all the cases just 
> increases the chances that someone somewhere copies them 
> incorrectly.

No. Some archs need to do "special" things at the irq disable point,
leave it open coded in the caller please.

Cheers,
Ben.


