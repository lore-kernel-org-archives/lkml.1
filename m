Return-Path: <linux-kernel-owner+w=401wt.eu-S1752106AbZIHUFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbZIHUFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 16:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbZIHUFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 16:05:24 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:20508 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbZIHUFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 16:05:24 -0400
MIME-Version: 1.0
In-Reply-To: <200909082138.15312.rjw@sisk.pl>
References: <b2cdc9f30909081157r3087f707ve3a0cff77f46941a@mail.gmail.com>
	 <200909082138.15312.rjw@sisk.pl>
Date: Tue, 8 Sep 2009 21:05:25 +0100
X-Google-Sender-Auth: 2dfd8e1748089e16
Message-ID: <b2cdc9f30909081305u61b896c1kff8caab3e003412e@mail.gmail.com>
Subject: Re: Machine resumes straight after suspend to RAM (or disk)
From: Alex Bennee <kernel-hacker@bennee.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: lkml <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/8 Rafael J. Wysocki <rjw@sisk.pl>:
> On Tuesday 08 September 2009, Alex Bennee wrote:
>> Hi,
>>
>> I thought I'd enable suspend and resume on my desktop machine so I
>> could save myself some time in the morning when I restart the machine.
>> The machine is fairly standard Intel Core Duo based system (lspci
>> attached). However when I execute pm-suspend (or Gentoo's own
>> hibernate-script) the system does suspend but resumes immediately.
<snip>
>>
>> So any ideas?
>
> What's in /proc/acpi/wakeup after a clean boot?

21:03 alex@danny/x86_64 [~] >cat /proc/acpi/wakeup
Device	S-state	  Status   Sysfs node
P0P1	  S4	 disabled
P0P3	  S4	 disabled  pci:0000:00:1e.0
P0P4	  S4	 disabled  pci:0000:00:1c.0
P0P5	  S4	 disabled
P0P6	  S4	 disabled
P0P7	  S4	 disabled
P0P8	  S4	 disabled
P0P9	  S4	 disabled
PS2K	  S4	 disabled  pnp:00:09
PS2M	  S4	 disabled  pnp:00:0a
MC97	  S4	 disabled
USB1	  S4	 disabled  pci:0000:00:1d.0
USB2	  S4	 disabled  pci:0000:00:1d.1
USB3	  S4	 disabled  pci:0000:00:1d.2
USB4	  S4	 disabled  pci:0000:00:1d.3
EUSB	  S4	 disabled  pci:0000:00:1d.7


-- 
Alex, homepage: http://www.bennee.com/~alex/
http://www.half-llama.co.uk
