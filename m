Return-Path: <linux-kernel-owner+w=401wt.eu-S1757112AbYGYWTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112AbYGYWTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 18:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbYGYWT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 18:19:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:33518 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbYGYWT1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 18:19:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,254,1215414000"; 
   d="scan'208";a="364764928"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: ACPI OSI disaster on latest HP laptops - critical temperature shutdown
Date: Fri, 25 Jul 2008 15:19:24 -0700
Message-ID: <9D39833986E69849A2A8E74C1078B6B3BB2AD4@orsmsx415.amr.corp.intel.com>
In-reply-to: <488A4F70.4010208@tremplin-utc.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: ACPI OSI disaster on latest HP laptops - critical temperature shutdown
Thread-Index: Acjuo1WYncE49fJJTQiASzh1fj1xpwAAFxVg
References: <200807241727.41715.trenn@suse.de> <alpine.LFD.1.10.0807241952270.6098@localhost.localdomain> <488A4F70.4010208@tremplin-utc.net>
From: "Moore, Robert" <robert.moore@intel.com>
To: "Eric Piel" <eric.piel@tremplin-utc.net>, "Len Brown" <lenb@kernel.org>,
       "Lin, Ming M" <ming.m.lin@intel.com>
Cc: "Thomas Renninger" <trenn@suse.de>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       "linux-acpi" <linux-acpi@vger.kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <ak@linux.intel.com>,
       "Christian Kornacker" <ckornacker@suse.de>
X-OriginalArrivalTime: 25 Jul 2008 22:19:25.0322 (UTC) FILETIME=[7F0636A0:01C8EEA4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The goal for ACPICA has gone from being a complete "reference
implementation" of the ACPI specification to being a "Windows
bug-for-bug compatible" ACPI implementation.

So when we report _OS("Microsoft Windows NT") and respond OK to all _OSI
queries with Microsoft strings, we mean it.

Bob


>-----Original Message-----
>From: Eric Piel [mailto:eric.piel@tremplin-utc.net]
>Sent: Friday, July 25, 2008 3:11 PM
>To: Len Brown
>Cc: Thomas Renninger; Arjan van de Ven; linux-acpi; Moore, Robert;
Linux
>Kernel Mailing List; Andi Kleen; Christian Kornacker
>Subject: Re: ACPI OSI disaster on latest HP laptops - critical
temperature
>shutdown
>
>Len Brown schreef:
>> Thomas,
>>
>> re: OSI(Windows...)
>>
>> Linux will continue to claim OSI compatibility with Windows
>> until the day when the majority of Linux systems
>> have passed a Linux compatibility test rather than
>> a Windows compatibility test.
>>
>> Re: OSI(Linux)
>>
>> I've looked at O(100) DSDT's that look at OSI(Linux),
>> and all but serveral systems from two vendors do it by mistake.
>> They simply copied it from the bugged Intel reference code.
>>
>> OSI(Linux) will _never_ be restored to Linux, ever.
>>
>Just out of curiosity, let's imagine that today HP decides to fix its
>BIOS. What would be the way to do it? Of course, without putting
>additional problems when Windows is booted.
>
>What they would want is to provide workarounds for each given version
of
>Windows and provide a completely ACPI-compliant version when Linux is
>running. I fail to see how it is possible possible to do that today.
>Well... they could detect Linux by checking that several OSI's for
>Windows pass, but that would be really a nasty kludge.
>
>So, am I understanding correctly that we are in a desperate need for a
>good OSI solution? Until then, we can only bash and complain at the
BIOS
>developers, but they have no way to fix the problems.
>
>Eric
