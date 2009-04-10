Return-Path: <linux-kernel-owner+w=401wt.eu-S935618AbZDJQ2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935618AbZDJQ2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 12:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935381AbZDJQ1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 12:27:18 -0400
Received: from www.tglx.de ([62.245.132.106]:34863 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935356AbZDJQ1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 12:27:17 -0400
Date: Fri, 10 Apr 2009 18:26:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Subject: Re: [2.6.29-git12] BUG: scheduling while atomic:
 swapper/0/0x10000100
In-Reply-To: <8db1092f0904100747w297a0daas9ebd05486d06e706@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0904101819070.21577@localhost.localdomain>
References: <8db1092f0904070037q426fd8dcx4aa48c70e40b5d6c@mail.gmail.com>  <20090409212028.7b2aa88c.akpm@linux-foundation.org>  <8db1092f0904100340g7b7eb310y805e8680a32e3ac8@mail.gmail.com>  <alpine.LFD.2.00.0904101329170.21577@localhost.localdomain>
 <8db1092f0904100747w297a0daas9ebd05486d06e706@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Apr 2009, Maciej Rutecki wrote:
> > We have a check for that in do_softirq, but none in do_IRQ. Can you
> > please apply the patch below and test whether it triggers ?
> 
> When I try connect with bluetooth, and connecting hangs, very often I
> observe high load of cpu, and system was very unresponsive. ksoftirqd
> has up to 100% load:
> http://unixy.pl/maciek/download/kernel/2.6.30-rc1-git3/laptop/img_0002.jpg
> 
> After this I reboot laptop.
> 
> >From syslog:
> http://unixy.pl/maciek/download/kernel/2.6.30-rc1-git3/laptop/syslog.txt

Is this with my patch applied ?

Thanks,

	tglx
