Return-Path: <linux-kernel-owner+w=401wt.eu-S1752433AbXCAOKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbXCAOKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 09:10:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbXCAOKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 09:10:35 -0500
Received: from sdcsmtp.europe.hp.net ([15.203.169.188]:42083 "EHLO
	sdcrelbas02.sdc.hp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752432AbXCAOKM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 09:10:12 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: minor device number request for /dev/kvm (kernel-based virtual machine)
Date: Thu, 1 Mar 2007 15:09:17 +0100
Message-ID: <93C4769E3BED6B42B7203BD6F065654C08C5DF0F@dmoexc01.emea.cpqcorp.net>
In-Reply-To: <45E6CF82.9090001@qumranet.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: minor device number request for /dev/kvm (kernel-based virtual machine)
Thread-Index: AcdcAo0kqpJJWYIFQcmqwjS/HA+gxwACJzVQ
References: <45975F61.4070506@qumranet.com> <93C4769E3BED6B42B7203BD6F065654C08C5D6D3@dmoexc01.emea.cpqcorp.net> <45E6BFD0.1060003@qumranet.com> <Pine.LNX.4.61.0703011401370.23355@yvahk01.tjqt.qr> <45E6CF82.9090001@qumranet.com>
From: "Mathiasen, Torben" <Torben.Mathiasen@hp.com>
To: "Avi Kivity" <avi@qumranet.com>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "kvm-devel" <kvm-devel@lists.sourceforge.net>
X-OriginalArrivalTime: 01 Mar 2007 14:10:06.0840 (UTC) FILETIME=[50815F80:01C75C0B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > If it does not increase memory usage, then possibly:
> >
> >   __register_chrdev_region(major, 0, (~0U) & MINORMASK, name);
> >                                   or (1<<MINORMASK)-1 if that's more
> clear
> >
> >
> 
> I'm more worried about something in the chardev bowels not supporting
>  >8bit minors well.
> 

I was under the impression that large minors was supported for misc.
Skimming the code that does not seem to be the case. Can someone
comment?

Torben 
