Return-Path: <linux-kernel-owner+w=401wt.eu-S933253AbXC1HEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253AbXC1HEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 03:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933439AbXC1HEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 03:04:34 -0400
Received: from www.osadl.org ([213.239.205.134]:50968 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933253AbXC1HEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 03:04:32 -0400
Subject: Re: [3/6] 2.6.21-rc4: known regressions
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, Jens Axboe <jens.axboe@oracle.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <b6a2187b0703261046r46782eedv64464ceddb44bc27@mail.gmail.com>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070318184919.GW752@stusta.de>
	 <b6a2187b0703251825l2b2ab9d3j43e17523cbca87ac@mail.gmail.com>
	 <20070326040509.GU16477@stusta.de>
	 <b6a2187b0703252237l4f662fb3n7f57dfb10360c4f6@mail.gmail.com>
	 <1174926407.7911.1.camel@chaos>
	 <b6a2187b0703261046r46782eedv64464ceddb44bc27@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 28 Mar 2007 09:04:28 +0200
Message-Id: <1175065468.4017.1.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-27 at 01:46 +0800, Jeff Chua wrote:
> On 3/27/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > > It's related. I tested without CONFIG_HPET_TIMER, and now my X60 can
> > > suspend and resume from RAM (s2ram). Even better, it works
> > > with/without CONFIG_NO_HZ.
> >
> > Does the patch below fix the HPET_TIMER=y case ?
> 
> Thomas, I tried, but it didn't help. Upon resume from ram, "date"
> still didn't advance.

Can you please issue a SysRq-Q in this situation and provide the dmesg
output ?

Thanks,

	tglx


