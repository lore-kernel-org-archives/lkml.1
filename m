Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbXCaQJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbXCaQJw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 12:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbXCaQJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 12:09:50 -0400
Received: from www.osadl.org ([213.239.205.134]:57162 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753281AbXCaQJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 12:09:48 -0400
Subject: Re: [PATCH v2] Add suspend/resume for HPET
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, Jens Axboe <jens.axboe@oracle.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       "Michael S. Tsirkin" <mst@mellanox.co.il>
In-Reply-To: <b6a2187b0703310901t42fe4752s55eb20d198788b22@mail.gmail.com>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <460BBD1B.4040308@ru.mvista.com>
	 <200703291531.18253.maximlevitsky@gmail.com>
	 <200703291546.48996.maximlevitsky@gmail.com>
	 <1175356272.28263.27.camel@localhost.localdomain>
	 <b6a2187b0703310901t42fe4752s55eb20d198788b22@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 31 Mar 2007 18:09:47 +0200
Message-Id: <1175357387.28263.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-01 at 00:01 +0800, Jeff Chua wrote:
> On 3/31/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > Jeff still seems to have problems with CONFIG_NO_HZ=n and it might be
> > caused by time keeping / tick management resume happening before the
> > HPET resume.
> 
> 
> me>Confirmed that suspend/resume disk/ram works on X60s with
> me>CONFIG_HPET_TIMER=y and CONFIG_NO_HZ unset.
> me> But suspend to disk still hang with CONFIG_NO_HZ unset.
> 
> 
> Oops, sorry. Typo (as a result copy/paste using mouse)
>     ... I actually meant CONFIG_NO_HZ "set".
> 
> Just to be clear, suspend to disk still hang with CONFIG_NO_HZ=y. It
> hang just before you see the percent saving %.

Ah, that's a different one then. In that path the timers should be
alive, but who knows.

	tglx


