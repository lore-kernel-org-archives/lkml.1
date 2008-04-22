Return-Path: <linux-kernel-owner+w=401wt.eu-S1755587AbYDVF0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbYDVF0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 01:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbYDVF0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 01:26:01 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:14087 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbYDVF0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 01:26:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=RDMxrgvYfcegexGQo4UrTK1I5wMBcI2UdrP1aMZvHaZ5Ma+X8ez/cQv5TcLRp/9agBNWjaQypiieEP5hkEhNkUPTIc3nrLg/wrY9yUhZCvhkQ+NBP6Pib58KEkrSqRdIfZaFR20slBrNcrin9lpd/jfKCFWln67R94D/pKao1Zg=
Message-ID: <480D75EF.9040902@gmail.com>
Date: Tue, 22 Apr 2008 07:21:51 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Justin Mattock <justinmattock@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: BIOS bug, APIC version if 0 for CPU#0
References: <dd18b0c30804212213x74716d5fx4bf91cbb99a01286@mail.gmail.com>
In-Reply-To: <dd18b0c30804212213x74716d5fx4bf91cbb99a01286@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Hello;
> with the latest git on a macbook the system can barely boot without
> freezing, a work around for me at leat is either disable smp, or once
> booted  turn on glxgears,or compiling the kernel i.g. when using the
> processors I'm not receiving a freeze, only when everything starts
> lowering down. in dmesg I'm noticing BIOS bug, APIC version is 0 for
> CPU#0! fixing up to 0x10. (tell you're hw vendor) could this be the
> reason for the system freezes?,

I don't think so. On my machine there's no freezes with latest git and:
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)

I've got exactly the same messages.

> also I didnt have a camera handy on me
> but the screen spit out = Bug spinlock lockup on CPU#0
> swapper/0. c17fa7c0 PID 0, comm: swapper not tainted.

Can you try to write down more of those bug messages?

> I dont have a problem disabling smp, except when I cat /proc/cpuinfo I
> don't see anything about my cores.

What exactly you expect to see in /proc/cpuinfp while smp is disabled?

> I know this is a stupid question
> but will it hurt the system if smp is disabled
> for the macbook pro ati chipset.?

No it won't.

-Jacek
