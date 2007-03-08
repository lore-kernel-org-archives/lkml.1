Return-Path: <linux-kernel-owner+w=401wt.eu-S965741AbXCGXnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965741AbXCGXnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965751AbXCGXnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:43:00 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55668 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965741AbXCGXm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:42:59 -0500
Date: Thu, 8 Mar 2007 00:45:52 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       Dan Hecht <dhecht@vmware.com>, Zachary Amsden <zach@vmware.com>,
       akpm@linux-foundation.org, ak@suse.de,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
Message-ID: <20070308004552.2f9a25d6@lxorguk.ukuu.org.uk>
In-Reply-To: <45EF05F0.7090700@goop.org>
References: <45EDD82F.90204@vmware.com>
	<1173225182.24738.507.camel@localhost.localdomain>
	<45EE0628.1080108@goop.org>
	<45EE08E8.2020008@vmware.com>
	<1173228544.24738.514.camel@localhost.localdomain>
	<45EE0D10.7070807@vmware.com>
	<1173230305.24738.529.camel@localhost.localdomain>
	<45EE1EA3.90803@vmware.com>
	<1173256666.24738.576.camel@localhost.localdomain>
	<45EEF966.6060902@goop.org>
	<20070307174957.GA31371@elte.hu>
	<45EF05F0.7090700@goop.org>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yep, the tsc has myriad problems; for Xen its the best of a bad lot. 
> Unfortunately in 10 years no clearly better alternative has appeared;
> maybe in 10 years there will be one.  It might even be the tsc.

TSC is essentially unusable for any kind of time related work. And I'd
disagree about the alternatives - the HPET and ACPI timers are not bad,
the CMOS timer can be used as an interrupting timer source, and there is
the old PC timer chip. All are superior to the TSC.

Finally for performance management work you've got cycle counters in the
debug side (with interrupt on overflow) which allow you to do management
of resources by cpu ticks or by memory bandwidth utilisation (Sun btw
have a fascinating paper somewhere on the latter)

Alan
