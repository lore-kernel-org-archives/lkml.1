Return-Path: <linux-kernel-owner+w=401wt.eu-S1755903AbYIPQmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbYIPQmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 12:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbYIPQmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 12:42:37 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:5024 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbYIPQmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 12:42:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tLAm386VPh/JOyJUpviV4g8Nowlv/d5Ei/1eggd17x6m1ngPjFSsmDVhVefb+hgI4X
         PFYIDi+VIDMRZbDZ8JuK9e1x+1lUMe8W3Mdd/3dVP5t2PPyUbKtwEJHdYBmVkdMAr/ug
         HvdQJDQzO6Z/N1DW2gta4Ijv8eTNlRwMcyZho=
Message-ID: <86802c440809160942w601691fbnb70a989acc5d98d3@mail.gmail.com>
Date: Tue, 16 Sep 2008 09:42:36 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] introduce boot_printk()
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, jbaron <jbaron@redhat.com>
In-Reply-To: <48CFD97C.6080002@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221465916-30889-1-git-send-email-yhlu.kernel@gmail.com>
	 <48CE983C.8040709@zytor.com>
	 <86802c440809151018k2c7874dfjc8e9791bee9365f9@mail.gmail.com>
	 <48CE9A5C.1030603@zytor.com>
	 <86802c440809151034ycd6442me679792880b03320@mail.gmail.com>
	 <1221575196.6943.24.camel@lappy.programming.kicks-ass.net>
	 <48CFD97C.6080002@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 9:06 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Peter Zijlstra wrote:
>>>
>>> every subsystem will have
>>> x86_printk
>>> acpi_printk
>>> pci_printk
>>
>> doesn't sound like an easily extensible interface, better would be
>> extending printk with a KERN_subsys tag like proposed.
>>
>
> That would be my thinking too.

will be printk(KERN_PCI, KERN_DEBUG ".....") ?
and it will be ...KERN_PCI will be int?


YH
