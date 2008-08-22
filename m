Return-Path: <linux-kernel-owner+w=401wt.eu-S1759340AbYHVB4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340AbYHVB4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 21:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbYHVB4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 21:56:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:49028 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbYHVBz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 21:55:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=a7XyOGax0PUGJYymUNs8DCO8kDpzRgIROOwafu0289fUaEoqt01/ZSWRotG//UrN8p
         4zbHQQGMmFx5mvuXVLVkJVFC1ixK+xdhdnT/tnYBeOem1mMjYE1RdyDJFk5W0xUDoiQY
         2D3YODXapSgt5JaM6ozCHBiO9mJ9mmItE3snY=
Message-ID: <86802c440808211855h50ea65faudc169e48f83e18e2@mail.gmail.com>
Date: Thu, 21 Aug 2008 18:55:58 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Joshua Hoblitt" <josh@hoblitt.com>
Subject: Re: [Bug 11388] New: 2.6.27-rc3 warns about MTRR range; only 3 of 16gb of memory is usable
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       j_kernel@hoblitt.com
In-Reply-To: <20080822011055.GI23377@hoblitt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080820180405.7f164450.akpm@linux-foundation.org>
	 <86802c440808201849k6665c395x5a5b871eca55addd@mail.gmail.com>
	 <20080821205558.GC23377@hoblitt.com>
	 <86802c440808211451u4483f88ft845cd20c3f23c53a@mail.gmail.com>
	 <20080821233317.GE23377@hoblitt.com>
	 <20080822001047.GF23377@hoblitt.com>
	 <86802c440808211728r4b5a7a37w929c2dd68616361d@mail.gmail.com>
	 <20080822002952.GG23377@hoblitt.com>
	 <20080822010014.GH23377@hoblitt.com>
	 <20080822011055.GI23377@hoblitt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 6:10 PM, Joshua Hoblitt <josh@hoblitt.com> wrote:
> Ugh - I just realized I forgot to type "-dirty" into grub after
> rebuilding the kernel.  Here is the new dmesg with the msr trace.
>
> -J
>
> --
> On Thu, Aug 21, 2008 at 03:00:14PM -1000, Joshua Hoblitt wrote:
>> I have applied your patch to the tip tree and rebuilt.  Still no msr
>> dump.
>>
>> -J
>>
>> --
>> On Thu, Aug 21, 2008 at 02:29:52PM -1000, Joshua Hoblitt wrote:
>> > Lol.  No - I thought you implied it was in the tip tree.  Sigh.  I'll
>> > try again.
>> >
[    0.429971]  MSR00000200: 00000000d0000000
[    0.433305]  MSR00000201: 0000000ff0000800

==> base: 0xd0000000 size: 0x10000000 UC

[    0.436638]  MSR00000202: 00000000e0000000
[    0.439971]  MSR00000203: 0000000fe0000800
==> base: 0xe000000 size: 0x2000000 UC

[    0.443304]  MSR00000204: 0000000000000006
[    0.446637]  MSR00000205: 0000000c00000800

==> base: 0 size 16G WB

[    0.449970]  MSR00000206: 0000000400000006
[    0.453303]  MSR00000207: 0000000fe0000800

==> base: 16G, size: 128M WB

[    0.456636]  MSR00000208: 0000000420000006
[    0.459970]  MSR00000209: 0000000ff0000800
==> base: 16g+128M, size 64M WB

[    0.463303]  MSR0000020a: 0000000000000000
[    0.466636]  MSR0000020b: 0000000000000000

[    0.469969]  MSR0000020c: 0000000000000000
[    0.473302]  MSR0000020d: 0000000000000000

it seems right.

can you send out /proc/cpuinfo

YH
