Return-Path: <linux-kernel-owner+w=401wt.eu-S1751800AbXBJTpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbXBJTpx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 14:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbXBJTpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 14:45:53 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:26941 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbXBJTpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 14:45:52 -0500
Date: Sat, 10 Feb 2007 11:41:55 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Patrick Ale" <patrick.ale@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: libsata tests started
Message-Id: <20070210114155.6f7433c8.randy.dunlap@oracle.com>
In-Reply-To: <8d158e1f0702100822i28d0bcds91cf27fc34534d2c@mail.gmail.com>
References: <8d158e1f0702100822i28d0bcds91cf27fc34534d2c@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Feb 2007 17:22:28 +0100 Patrick Ale wrote:

> Hi,
> 
> And now for something completely different.
> 
> I started the libsata tests on one of the four machines I'll be doing
> these tests on.

Hi,
What are the libsata tests and where are they, please?

> At the moment I'm testing on 'lilith', which is my multi-harddisk
> server and playground.
> 
> At the moment I am hammering /dev/sda5, which is an ext4dev partition
> with bonnie++.
> sda is attached to my onboard ATA controller, driven by pata_via.

So you are testing libata and ext4dev at the same time...

> At the same moment I am doing a full resync of my MD RAID1 device with
> two stripes.
> Both stripes are on seperate 120GB disks, where one disk is attached
> to a PCI controller, driven by pata_sil680 and one disk attached to an
> onboard Promise ATA controller, driven by pata_pdc2027x.
> 
> I confirmed that all devices are driven by the new libsata drivers, it
> can't be very much differentr since I disabled the entire "old" IDE
> stack. :)

libsata == libata ?

> So, let's see how things go, so far so good.
> 
> For those who are interested, I attached the output of an lspci -vvv.
> The file name has "stage1" included since I'll be adding my PCI cards
> one by one to isolate problems to a single bus or card.
> 
> I hope my test input helps a bit.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
