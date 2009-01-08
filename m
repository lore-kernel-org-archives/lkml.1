Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbZAHKDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbZAHKDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 05:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbZAHKDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 05:03:09 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:6058 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbZAHKDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 05:03:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=cNlIdrZRLlKwyctOx/M6Umfoqymi/MXfWg2ETeB/+0+sUoTZ50V9V0yvSrlkpypSFS
         MIkXdUOmw6c4VyCTFkPCGJiZiGowhy2SHKtQBv6tx8qzGG6EETKPtFsanKAdDn2y5b5i
         o90JU2zFaWPf1mgJZ3T3+huA4LoInB5GSLlkQ=
Message-ID: <86802c440901080203m221def59qf1cd9fa3d017fd38@mail.gmail.com>
Date: Thu, 8 Jan 2009 02:03:04 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Beschorner Daniel" <Daniel.Beschorner@facton.com>
Subject: Re: hwinfo problem since 2.6.28
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <3C59DB883F7B0B4D8096010D45ACCD13C73EA2@exch.facton.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Aclv3DYqPGwhSzk9Qg22IVoJDubF+w==>
	 <3C59DB883F7B0B4D8096010D45ACCD13C73EA2@exch.facton.local>
X-Google-Sender-Auth: 8d3691479a77ceb1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2009 at 12:53 AM, Beschorner Daniel
<Daniel.Beschorner@facton.com> wrote:
> Since 2.6.28 my hwinfo tool crashes badly on 2 years old OpenSuSE 10.2
> x64/SMP.
> Older kernels run fine, I did a "make oldconfig" and rather used
> defaults (just skipping low-64k checks).
> This seems to be the only affected binary as far I can see.
> Did I miss a new legacy/compat option or is it a bug?
>
> Thank you!
> Daniel
>
> hwinfo: Corrupted page table at address 7fd04de3ec00
> PGD 7dc33067 PUD 3efe067 PMD 27b83067 PTE fffffffffffffbff
> Bad pagetable: 000d [#9] SMP
> last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:06:05.0/class
> CPU 0
> Modules linked in:
> Pid: 13700, comm: hwinfo Tainted: G      D    2.6.28 #7
> RIP: 0033:[<00007fd04d66f7f2>]  [<00007fd04d66f7f2>] 0x7fd04d66f7f2
> RSP: 002b:00007fff55ed2c68  EFLAGS: 00010202
> RAX: 00000000015d1fb0 RBX: 0000000000001000 RCX: fefefefefefefeff
> RDX: 0000000000000001 RSI: 00007fd04de3ec00 RDI: 00000000015d1fb0
> RBP: 000000000009fc00 R08: ffffffffff000000 R09: 00007fd04d6fbd60
> R10: ffffffffffffffff R11: 0000000000000000 R12: 00007fd04d9a72f6
> R13: 000000000009f000 R14: 0000000000000003 R15: 00000000015b4010
> FS:  00007fd04dec06f0(0000) GS:ffffffff80619540(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00007fd04de3ec00 CR3: 000000007de55000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process hwinfo (pid: 13700, threadinfo ffff88007dff2000, task
> ffff88007ed934a0)
>
> RIP  [<00007fd04d66f7f2>] 0x7fd04d66f7f2
>  RSP <00007fff55ed2c68>
> ---[ end trace 742092d3bead57cc ]---
>

bootlog with debug in command line?

YH
