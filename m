Return-Path: <linux-kernel-owner+w=401wt.eu-S1760204AbYDVQvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204AbYDVQvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 12:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755078AbYDVQvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 12:51:42 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:30642 "EHLO
	outbound7-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755025AbYDVQvk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 12:51:40 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0JZQK5C-02-331-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: WARNING: at drivers/base/sys.c:183 sysdev_driver_register+0x75/0x12e()
Date: Tue, 22 Apr 2008 11:51:21 -0500
Message-ID: <6453C3CB8E2B3646B0D020C112613273093908@sausexmb4.amd.com>
In-Reply-To: <Pine.LNX.4.64.0804221609130.12972@jikos.suse.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: WARNING: at drivers/base/sys.c:183 sysdev_driver_register+0x75/0x12e()
Thread-Index: AcikiCyATX5IB94ESQ6hCsQe9AH+wQAEKqyg
References: <Pine.LNX.4.64.0804221609130.12972@jikos.suse.cz>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Jiri Kosina" <jkosina@suse.cz>, <davej@codemonkey.org.uk>,
       <lenb@kernel.org>
Cc: <linux-acpi@vger.kernel.org>, "Greg KH" <greg@kroah.com>,
       <linux-kernel@vger.kernel.org>, <cpufreq@lists.linux.org.uk>
X-OriginalArrivalTime: 22 Apr 2008 16:51:22.0007 (UTC) FILETIME=[18063270:01C8A499]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: cpufreq-bounces@lists.linux.org.uk 
> [mailto:cpufreq-bounces@lists.linux.org.uk] On Behalf Of Jiri Kosina
> Sent: Tuesday, April 22, 2008 9:12 AM
> To: davej@codemonkey.org.uk; lenb@kernel.org
> 
> Hi,
> 
> I am getting the acpi-cpufreq-drivercore warning below when booting 
> current git (807501475)
> 
> powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3000+ 
> processors (1 cpu 
> cores) (version 2.20.00)
> powernow-k8: BIOS error - no PSB or ACPI _PSS objects
> sysdev: class cpu: driver (ffffffff8057fd10) has already been 
> registered to a class, something is wrong, but will forge on!
> 
Why is the acpi-cpufreq driver trying to
instantiate on an AMD processor?  It shouldn't
do that.

PowerNow! failed to load because the BIOS wasn't 
set up correctly.  But the acpi-cpufreq driver
shouldn't have loaded at all.

-Mark Langsdorf
Operating System Research Center
AMD

