Return-Path: <linux-kernel-owner+w=401wt.eu-S1753125AbYLIIaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbYLIIaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 03:30:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbYLIIaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 03:30:46 -0500
Received: from ag-out-0708.google.com ([72.14.246.246]:49192 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbYLIIap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 03:30:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=x5CZkDNapG4ID5x5jErXlxq5o1saIGfzuD6lS5p4DuRQchrX8XlDJ+ut4QqWgb6Q+I
         W05zsvES+dU+q1qXPHCEd7bmnbU7Xd7oDobD2mz3xy6j2gF7GcMdfW+0WZOTQOTRWeli
         VKi3rOTJWTmDUG4Fn1mH9rkjWnPbMaCj87vbg=
Message-ID: <12bfabe40812090030v7d8bcd6aq99438d18b808d32f@mail.gmail.com>
Date: Tue, 9 Dec 2008 09:30:42 +0100
From: "Giangiacomo Mariotti" <gg.mariotti@gmail.com>
To: "Mikael Abrahamsson" <swmike@swm.pp.se>
Subject: Re: OFFLIST Re: [HW PROBLEM] Intel I7 MCE. Erratum or not?
Cc: "Andi Kleen" <ak@linux.intel.com>,
       "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0812090857590.18782@uplift.swm.pp.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12bfabe40812060421j10c93b3dg75a48aa304f633e8@mail.gmail.com>
	 <alpine.DEB.1.10.0812081314010.18782@uplift.swm.pp.se>
	 <493D296B.1080205@linux.intel.com>
	 <alpine.DEB.1.10.0812081724080.18782@uplift.swm.pp.se>
	 <493D6FB4.9090909@linux.intel.com>
	 <alpine.DEB.1.10.0812082145410.18782@uplift.swm.pp.se>
	 <12bfabe40812082146r3ea000em7a8f725101a50bd5@mail.gmail.com>
	 <alpine.DEB.1.10.0812090737410.18782@uplift.swm.pp.se>
	 <12bfabe40812082319x4ed6c9m5b744e51cdd3d838@mail.gmail.com>
	 <alpine.DEB.1.10.0812090857590.18782@uplift.swm.pp.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2008 at 9:00 AM, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
> On Tue, 9 Dec 2008, Giangiacomo Mariotti wrote:
>
>> In its i386 version the mce didn't get logged for me too, but I noticed
>> something like an option for non critical MCEs wasn't configured in the i386
>> kernel. That might be the cause, or it's just a problem for the 64 bit
>> version. Anyway, as I've already posted here lkml.org/lkml/2008/12/9/4,
>> rebooting with a kexec completely removes the MCE, so I guess it's a bios
>> problem.
>
> Yes, this bios seems very flakey. After I have booted linux a few times
> (haven't narrowed down the problem exactly) both rtl8169 devices are removed
> for me. They're completely gone, lspci doesn't show them, neither are they
> shown in bios bootup screen. The built in bios cable testing option doesn't
> find them either.
>
> Factory default:ing the BIOS usually bring them back. I have resorted to a
> PCI 32bit e1000 for network connectivity because I grew bored of resetting
> the bios every couple of times I booted linux on it.
>
> Vista doesn't cause this problem from what I have seen (but it might, I
> don't have enough data).
>
> --
> Mikael Abrahamsson    email: swmike@swm.pp.se
>
Yes, that happens to me too regularly. Also now my bios completely
freezes after having successfully done the dmi pool check at boot if I
try to boot directly from my HD, so I have to boot from my usb dvd
writer. At the moment I successfully booted that rescuecd in 64 bit
mode and the kexeced into my 2.6.27.8 debian system. I still haven't
tried to make a bootable cd with grub and see if I can also boot
directly into my HD at boot or if not even Grub can see it. The very
good point of using the kexec method is that, even if my bios cannot
boot my hd directly, I can bypass it. But I still don't know if I have
this problem too.
