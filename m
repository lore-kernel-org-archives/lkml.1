Return-Path: <linux-kernel-owner+w=401wt.eu-S965457AbXA3OOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965457AbXA3OOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965458AbXA3OOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:14:41 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52484 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965457AbXA3OOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:14:40 -0500
Date: Tue, 30 Jan 2007 14:25:31 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Jean Delvare <jdelvare@suse.de>, Daniel Drake <dsd@reactivated.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: via irq quirk breakage
Message-ID: <20070130142531.790b13a0@localhost.localdomain>
In-Reply-To: <45BEAEE3.9080003@yahoo.com.au>
References: <45B6A94A.3010006@yahoo.com.au>
	<200701291600.32580.jdelvare@suse.de>
	<45BEAEE3.9080003@yahoo.com.au>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Well it works because I know I need that particular quirk applied to
> my USB IRQ. But definitely it is a hack because I've otherwise got no
> idea what I'm doing ;)

The VIA quirks depend upon so many interacting things - the BIOS irq
routing data being correct, the ACPI tables being coded by someone who
had more than ten minutes to ship the product etc.

If you are feeling really really bored Nick you can work each IRQ routing
back using the chip data sheet. It's utterly tedious but may give an
answer.

Alan
