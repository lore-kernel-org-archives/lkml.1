Return-Path: <linux-kernel-owner+w=401wt.eu-S1753398AbXCZRqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbXCZRqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 13:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbXCZRqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 13:46:33 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:50046 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbXCZRqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 13:46:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nVd0MEZVZd11l0x6YE84uMsiFlM0wn2pRIn4sKvcZ4v210xOYyYv7TYhhWyqI/MxK2bzOfvVeR/tWHTnR4S97q9yPch4SSYOQI4L0S0xKx4nHPi0CXQwfX2eSnxZov4dqepLJeNbryYKfVVnZ6tvVhrNP7/HNcDS4ez+TtVqUPE=
Message-ID: <b6a2187b0703261046r46782eedv64464ceddb44bc27@mail.gmail.com>
Date: Tue, 27 Mar 2007 01:46:28 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [3/6] 2.6.21-rc4: known regressions
Cc: "Adrian Bunk" <bunk@stusta.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "Jens Axboe" <jens.axboe@oracle.com>, "Len Brown" <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, jgarzik@pobox.com,
       linux-ide@vger.kernel.org, "Michael S. Tsirkin" <mst@mellanox.co.il>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1174926407.7911.1.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070318184919.GW752@stusta.de>
	 <b6a2187b0703251825l2b2ab9d3j43e17523cbca87ac@mail.gmail.com>
	 <20070326040509.GU16477@stusta.de>
	 <b6a2187b0703252237l4f662fb3n7f57dfb10360c4f6@mail.gmail.com>
	 <1174926407.7911.1.camel@chaos>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/27/07, Thomas Gleixner <tglx@linutronix.de> wrote:

> > It's related. I tested without CONFIG_HPET_TIMER, and now my X60 can
> > suspend and resume from RAM (s2ram). Even better, it works
> > with/without CONFIG_NO_HZ.
>
> Does the patch below fix the HPET_TIMER=y case ?

Thomas, I tried, but it didn't help. Upon resume from ram, "date"
still didn't advance.

Thanks,
Jeff.
