Return-Path: <linux-kernel-owner+w=401wt.eu-S1756231AbYG3AUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbYG3AUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 20:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbYG3AU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 20:20:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58396 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752489AbYG3AU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 20:20:27 -0400
Date: Wed, 30 Jul 2008 01:00:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>, "Mike Travis" <travis@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>, "Jack Steiner" <steiner@sgi.com>,
       "Alan Mayer" <ajm@sgi.com>, "Cliff Wickman" <cpw@sgi.com>
Subject: Re: kernel BUG at arch/x86/kernel/io_apic_64.c:357!
Message-ID: <20080730010044.06e7442b@lxorguk.ukuu.org.uk>
In-Reply-To: <m17ib48etp.fsf@frodo.ebiederm.org>
References: <20080729160939.GA4484@linux.vnet.ibm.com>
	<86802c440807291135m7f8e2163xdde14545e311649a@mail.gmail.com>
	<86802c440807291220t7813effcwb32ae6c18e3cddfe@mail.gmail.com>
	<m1d4kwbg8f.fsf@frodo.ebiederm.org>
	<488F96DD.6020505@sgi.com>
	<86802c440807291521k6e6277b5ta05b180d0d1c963a@mail.gmail.com>
	<m17ib48etp.fsf@frodo.ebiederm.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 16:12:50 -0700
ebiederm@xmission.com (Eric W. Biederman) wrote:

> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
> 
> >> But this would be a show stopper for SGI being able to ship systems if the
> >> distros do not want to waste this much memory and won't set NR_CPUS=4096.
> >
> > wonder if nr_irqs need to be probed dynamically too.
> 
> NR_IRQS simply needs to die.

Agreed - it would also be nice to bite the bullet at the same time and
stop using dev->irq as an integer in an increasingly fake and imaginary
numberspace and instead make it an object with a description and other
properties. That would make "no IRQ" NULL, let us display meaningful IRQ
strings and the like as well as ensuring nobody tries to abuse NR_IRQ and
hardcoded similar knowledge for arrays

Alan
