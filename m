Return-Path: <linux-kernel-owner+w=401wt.eu-S1757246AbYDVGK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246AbYDVGK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 02:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753118AbYDVGKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 02:10:14 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:56397 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbYDVGKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 02:10:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eN7dBGOUWTk/Cp/bkTfmco04Fot7bXbIuAgTIt+FxXjAFDNeXdeTPQ8HbLvrmJb3SrX9n/0glhGe9cf4vKTZHnEwgR4bztGp9pqDpPw/LBnoe0PhKWAMyoEVVHNEv5JEjdPB+APEz6C3lXor6zGDfTrOq3wG5FhfLzOqrBz1Bb8=
Message-ID: <dd18b0c30804212310h29938c02r86aaab49b327b550@mail.gmail.com>
Date: Tue, 22 Apr 2008 06:10:11 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Jacek Luczak" <difrost.kernel@gmail.com>
Subject: Re: BIOS bug, APIC version if 0 for CPU#0
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <480D75EF.9040902@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30804212213x74716d5fx4bf91cbb99a01286@mail.gmail.com>
	 <480D75EF.9040902@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 5:21 AM, Jacek Luczak <difrost.kernel@gmail.com> wrote:
> Hi,
>
>
>  > Hello;
>  > with the latest git on a macbook the system can barely boot without
>  > freezing, a work around for me at leat is either disable smp, or once
>  > booted  turn on glxgears,or compiling the kernel i.g. when using the
>  > processors I'm not receiving a freeze, only when everything starts
>  > lowering down. in dmesg I'm noticing BIOS bug, APIC version is 0 for
>  > CPU#0! fixing up to 0x10. (tell you're hw vendor) could this be the
>  > reason for the system freezes?,
>
>  I don't think so. On my machine there's no freezes with latest git and:
>  ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
>  BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
>  ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
>  BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
>
>  I've got exactly the same messages.

Are you using a macbook aswell?

>
>
>  > also I didnt have a camera handy on me
>  > but the screen spit out = Bug spinlock lockup on CPU#0
>  > swapper/0. c17fa7c0 PID 0, comm: swapper not tainted.
>
>  Can you try to write down more of those bug messages?

Yeah,

>
>
>  > I dont have a problem disabling smp, except when I cat /proc/cpuinfo I
>  > don't see anything about my cores.
>
>  What exactly you expect to see in /proc/cpuinfp while smp is disabled?

under smp I see cpu cores. disabling smp I dont see cpu cores, under
cat /proc/cpuinfo.


>
>
>  > I know this is a stupid question
>  > but will it hurt the system if smp is disabled
>  > for the macbook pro ati chipset.?
>
>  No it won't.
>
>  -Jacek
>

Cool as long as the system Is o.k. disabling smp.  What about x86: PAT
support is disabled. how do I enable this option?
regards;

-- 
Justin P. Mattock
