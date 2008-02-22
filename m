Return-Path: <linux-kernel-owner+w=401wt.eu-S934559AbYBVKLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934559AbYBVKLj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 05:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbYBVKLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 05:11:31 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56391 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751715AbYBVKLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 05:11:30 -0500
Date: Fri, 22 Feb 2008 10:00:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ian Campbell <ijc@hellion.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Joel Becker <Joel.Becker@oracle.com>, Jody Belka <lists-lkml@pimb.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Mika Penttila <mika.penttila@kolumbus.fi>
Subject: Re: 2.6.25-rc1 xen pvops regression
Message-ID: <20080222100034.1e78d661@core>
In-Reply-To: <47BE9C18.5060202@firstfloor.org>
References: <20080212235404.GY7980@pimb.org>
	<47B2DBA5.6030001@goop.org>
	<20080214022744.GA4160@mail.oracle.com>
	<47B3F2DC.8080707@goop.org>
	<20080215202336.GE26034@mail.oracle.com>
	<1203274161.27987.6.camel@localhost.localdomain>
	<20080218104025.GA15899@ca-server1.us.oracle.com>
	<1203458366.26910.15.camel@cthulhu.hellion.org.uk>
	<47BBDA20.8030105@zytor.com>
	<1203497511.26910.39.camel@cthulhu.hellion.org.uk>
	<47BCA275.7000504@goop.org>
	<1203546597.26910.74.camel@cthulhu.hellion.org.uk>
	<47BDEA11.6010302@goop.org>
	<47BDEB57.5040203@zytor.com>
	<47BDEF36.8000903@goop.org>
	<1203631956.28436.4.camel@cthulhu.hellion.org.uk>
	<47BDF9C7.6040400@zytor.com>
	<47BE0017.1020205@goop.org>
	<47BE0228.7020204@zytor.com>
	<1203665106.28436.19.camel@cthulhu.hellion.org.uk>
	<20080222092855.6ace8845@core>
	<47BE9C18.5060202@firstfloor.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually I switched 64bit over to trust e820 completely and not
> reserve 640k-1MB explicitly some time ago
> and AFAIK there hasn't been any reports that it causes problems.
> 
> So presumably trusting e802 is ok on modern systems (2003+)

Apparently so - at least 64bit capable ones. We do still sort the entries
to remove zero length records and other suprises.

Alan
