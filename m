Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbYIPQIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbYIPQIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 12:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbYIPQIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 12:08:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51927 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbYIPQIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 12:08:13 -0400
Message-ID: <48CFD97C.6080002@zytor.com>
Date: Tue, 16 Sep 2008 09:06:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jbaron <jbaron@redhat.com>
Subject: Re: [PATCH] introduce boot_printk()
References: <1221465916-30889-1-git-send-email-yhlu.kernel@gmail.com>	 <48CE983C.8040709@zytor.com>	 <86802c440809151018k2c7874dfjc8e9791bee9365f9@mail.gmail.com>	 <48CE9A5C.1030603@zytor.com>	 <86802c440809151034ycd6442me679792880b03320@mail.gmail.com> <1221575196.6943.24.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1221575196.6943.24.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
>>
>> every subsystem will have
>> x86_printk
>> acpi_printk
>> pci_printk
> 
> doesn't sound like an easily extensible interface, better would be
> extending printk with a KERN_subsys tag like proposed.
> 

That would be my thinking too.

	-hpa
