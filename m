Return-Path: <linux-kernel-owner+w=401wt.eu-S1760205AbXHXUt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205AbXHXUt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 16:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbXHXUtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 16:49:51 -0400
Received: from tisolutions.biz ([62.253.227.66]:1454 "EHLO
	sideshow-bob.tisolutions.biz" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752589AbXHXUtu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 16:49:50 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.0.6487.1
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: "exception Emask: 0x42" errors with 2.6.22.x and SATA drives
Date: Fri, 24 Aug 2007 21:49:45 +0100
Message-ID: <94439DDF32D7464A916B5068EFF76B3B0225E6D5@bart.tisolutions.biz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: "exception Emask: 0x42" errors with 2.6.22.x and SATA drives
Thread-Index: Acfmgp6kQFsFRSxYTNy7ZGo/yAJ8WgABUP8Q
From: "Dermot Bradley" <dermot.bradley@sla-mobile.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

> > I'm getting the following errors on occasion:
> >
> > Aug 24 13:19:22 playpbx kernel: APIC error on CPU0: 00(40)
> > Aug 24 13:19:33 playpbx kernel: APIC error on CPU0: 40(40)
>
> This is not good.

I've two things in mind to try:

(1) there is 1 newer official BIOS release and 2 beta BIOSes out for
this motherboard. The recent official BIOS (0901) does mention Linux:

   "Fixed Red Hat Enterprise Linux 4 installation failed"

So maybe a BIOS update will fix things.

(2) I will try booting with the "noapic" kernel option to see what
difference that makes.

> Neither are good, the latter is probably a drive firmware problem and
> the kernel will give up using NCQ with it if it keeps doing that,
> which should be just fine.

So I guess these drives should be added to the ata_blacklist_entry in
libata-core.c with ATA_HORKAGE_NONCQ?




Stirk, Lamont & Associates Ltd.
Registered Address: Thomas Andrews House, Queens Road, Belfast,  BT3 9DU
Registered in Northern Ireland, Number: NI 47983. VAT Number: 832 2778 22

