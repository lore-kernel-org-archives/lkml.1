Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbYIPSRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbYIPSRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 14:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbYIPSRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 14:17:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48380 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbYIPSRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 14:17:17 -0400
Message-ID: <48CFF7DF.6010404@zytor.com>
Date: Tue, 16 Sep 2008 11:15:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jbaron <jbaron@redhat.com>
Subject: Re: [PATCH] introduce boot_printk()
References: <1221465916-30889-1-git-send-email-yhlu.kernel@gmail.com>	 <48CE983C.8040709@zytor.com>	 <86802c440809151018k2c7874dfjc8e9791bee9365f9@mail.gmail.com>	 <48CE9A5C.1030603@zytor.com>	 <86802c440809151034ycd6442me679792880b03320@mail.gmail.com>	 <1221575196.6943.24.camel@lappy.programming.kicks-ass.net>	 <48CFD97C.6080002@zytor.com>	 <86802c440809161045q2f6d80f1yb6e79f32c6e0c303@mail.gmail.com>	 <48CFF281.7010101@zytor.com> <86802c440809161110q1fc3d66vedcaa32dea2b2233@mail.gmail.com>
In-Reply-To: <86802c440809161110q1fc3d66vedcaa32dea2b2233@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> you still can use
> pci_printk(v, KERN_PCI KERN_DEBUG "...\n");
> 
> if vprintk is expanded to handle KERN_PCI and other tags...
> or even you could use
> pci_printk(v, KERN_ACPI KERN_DEBUG "...\n");
> 

And the point of this, other than sheer verbosity?

	-hpa
