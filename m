Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbXHBKyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbXHBKyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 06:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbXHBKyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 06:54:01 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44750 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751942AbXHBKyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 06:54:01 -0400
Date: Thu, 2 Aug 2007 12:00:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
       trenn@suse.de, pavel@ucw.cz, mjg59@srcf.ucam.org, lenb@kernel.org
Subject: Re: 2.6.22 regression: thermal trip points
Message-ID: <20070802120014.1d08830a@the-village.bc.nu>
In-Reply-To: <p731wemnre6.fsf@bingen.suse.de>
References: <46B1988C.3090302@t-online.de>
	<20070802015248.45a40717.akpm@linux-foundation.org>
	<p731wemnre6.fsf@bingen.suse.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Also it runs the system out of spec and is similar to overclocking
> which we also do not support.

We do not systematically prevent overclocking. There are lots of cases
where altering the trip points is helpful, and if you look in vendor
bugzilla databases there are multiple moans from people whose laptops now
run slow, or in many cases are simply unusable as a result of Len's
change.

Given you can achieve some of the same result by not loading the relevant
ACPI code in the first place your argument makes no rational sense at all.

Set a taint flag, print a loud message but don't stop users actually
doing things they intend as root. Or have you forgotten the original Unix
philosophy too ?

> > Here we had obviously-useful-to-you functionality which was taken away
> > without, afaik, providing any alternative.
> 
> I don't think it's that unreasonable to require source code modifications
> for anything that can kill hardware.

As root you can erase the bios, lock the hard disk with a random
password, reflash your video card .... 

Sorry Andi, you simply do not know better than all end users.

Alan
