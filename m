Return-Path: <linux-kernel-owner+w=401wt.eu-S933298AbXCZB0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298AbXCZB0E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 21:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933325AbXCZBZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 21:25:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:18458 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933318AbXCZBZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 21:25:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ty46UdU6Jm/SZWN2xkEIu5AZ1m7LQ9vnSHtdKpqbsBXG7t95t57ZOBQ/1h45PHUnQtVkr3Etm1ZwlfI0lR9vduNxmTeTFPJQgcaSglb/cApROd0LJG3p3JUdDyt/nYTpNnpxo8Z2rJgUZH87e7mbcNRwC+b40ruD65u3JkvCZSU=
Message-ID: <b6a2187b0703251825l2b2ab9d3j43e17523cbca87ac@mail.gmail.com>
Date: Mon, 26 Mar 2007 09:25:51 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: [3/6] 2.6.21-rc4: known regressions
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Dave Jones" <davej@redhat.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Maxim Levitsky" <maximlevitsky@gmail.com>,
       "Mike Harris" <atarimike@wavecable.com>,
       "Marcus Better" <marcus@better.se>, "Ray Lee" <ray-lk@madrabbit.org>,
       "Alexey Starikovskiy" <alexey.y.starikovskiy@linux.intel.com>,
       "Len Brown" <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       "Thomas Meyer" <thomas@m3y3r.de>, jgarzik@pobox.com,
       linux-ide@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Soeren Sonnenburg" <kernel@nn7.de>
In-Reply-To: <20070318184919.GW752@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070318184919.GW752@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/19/07, Adrian Bunk <bunk@stusta.de> wrote:

> Subject    : ThinkPad doesn't resume from suspend to RAM
> References : http://lkml.org/lkml/2007/2/27/80
>              http://lkml.org/lkml/2007/2/28/348
> Submitter  : Jens Axboe <jens.axboe@oracle.com>
>              Jeff Chua <jeff.chua.linux@gmail.com>
> Status     : unknown
>
>
> Subject    : suspend to disk hangs
> References : http://lkml.org/lkml/2007/3/6/142
> Submitter  : Jeff Chua <jeff.chua.linux@gmail.com>
> Status     : unknown

The good news is on 2.6.21-rc5, suspend to disk, and resume from disk works.
But, it only works with CONFIG_NO_HZ unset.

Setting CONFIG_NO_HZ will cause suspend to disk to hang just before
saving memory to disk.

Resume from RAM (s2ram) still broke (tried with or without
CONFIG_NO_HZ). Suspend to RAM seems ok, but upon resume, the screen
will only display "inu" and only after pressing the power button will
the system return to console. But "date" still doesn't advance.

Thanks,
Jeff.
