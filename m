Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbYIPRoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbYIPRoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 13:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbYIPRob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 13:44:31 -0400
Received: from gw.goop.org ([64.81.55.164]:44892 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913AbYIPRoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 13:44:30 -0400
Message-ID: <48CFF076.8070500@goop.org>
Date: Tue, 16 Sep 2008 10:44:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jbaron <jbaron@redhat.com>
Subject: Re: [PATCH] introduce boot_printk()
References: <1221465916-30889-1-git-send-email-yhlu.kernel@gmail.com>	 <48CE983C.8040709@zytor.com>	 <86802c440809151018k2c7874dfjc8e9791bee9365f9@mail.gmail.com>	 <48CE9A5C.1030603@zytor.com>	 <86802c440809151034ycd6442me679792880b03320@mail.gmail.com>	 <1221575196.6943.24.camel@lappy.programming.kicks-ass.net>	 <48CFD97C.6080002@zytor.com> <86802c440809160942w601691fbnb70a989acc5d98d3@mail.gmail.com>
In-Reply-To: <86802c440809160942w601691fbnb70a989acc5d98d3@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Tue, Sep 16, 2008 at 9:06 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>   
>> Peter Zijlstra wrote:
>>     
>>>> every subsystem will have
>>>> x86_printk
>>>> acpi_printk
>>>> pci_printk
>>>>         
>>> doesn't sound like an easily extensible interface, better would be
>>> extending printk with a KERN_subsys tag like proposed.
>>>
>>>       
>> That would be my thinking too.
>>     
>
> will be printk(KERN_PCI, KERN_DEBUG ".....") ?
> and it will be ...KERN_PCI will be int?
>   

#define X86_DEBUG    KERN_DEBUG SUBSYS_X86
...
    printk(X86_DEBUG "woozle failed the wibble\n);


    J
