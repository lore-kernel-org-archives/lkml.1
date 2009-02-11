Return-Path: <linux-kernel-owner+w=401wt.eu-S1758326AbZBKSxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326AbZBKSxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 13:53:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756781AbZBKSww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 13:52:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:40295 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbZBKSww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 13:52:52 -0500
Message-ID: <49931E54.7000305@kernel.org>
Date: Wed, 11 Feb 2009 10:52:04 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Morten P.D. Stevens" <mstevens@win-professional.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: warning in arch/x86/kernel/cpu/mtrr/generic.c:400 with 2.6.29-rc3
 on IBM x3400
References: <B4ED8DE8E195E84A872496A085BC07822F18@exchange01.corp.win-professional.com> <B4ED8DE8E195E84A872496A085BC07822F1D@exchange01.corp.win-professional.com> <20090209234528.GA862@elte.hu> <4990E90D.30005@kernel.org> <B4ED8DE8E195E84A872496A085BC07822F21@exchange01.corp.win-professional.com> <86802c440902101052m223792ddi43d27423844b1d5b@mail.gmail.com> <B4ED8DE8E195E84A872496A085BC07822F22@exchange01.corp.win-professional.com> <4991E752.8010903@kernel.org> <B4ED8DE8E195E84A872496A085BC07822F23@exchange01.corp.win-professional.com> <86802c440902102106o54e4ea2fua4d108c8564ff8a@mail.gmail.com> <B4ED8DE8E195E84A872496A085BC07822F2A@exchange01.corp.win-professional.com>
In-Reply-To: <B4ED8DE8E195E84A872496A085BC07822F2A@exchange01.corp.win-professional.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Morten P.D. Stevens wrote:
> Hi,
> 
>> so there is some problem with your BIOS, please ask the vendor to
>> provide one to make
>> 2.6.24 happy.
> 
> I'll report the issue to the IBM support.
> 
> on our IBM x3400 servers running RHEL the same output:
> 
> 2.6.18-92.1.10.el5 #
> 
> reg00: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
> reg01: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
> reg02: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
> reg03: base=0xbff80000 (3071MB), size=196608MB: uncachable, count=1

so that bios need to be fixed too.

> 
> and in dmesg:
> 
> mtrr: type mismatch for d0000000,1000000 old: uncachable new:
> write-combining
want add one entry for xwindow with your display card.
> 
> 
> Is this a big problem for direct usage? The performance on these servers
> is still fine...?
x window could be some slow.

YH
