Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab0BJVjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 16:39:15 -0500
Received: from mail.gmx.net ([213.165.64.20]:37719 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751640Ab0BJVjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 16:39:13 -0500
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX19z3aAUqlhzWWaj5yagxnn9DODENf3+6NvcmUPmbL
	Px2k0bHfTYUjIE
Date: Wed, 10 Feb 2010 23:42:40 +0200 (EET)
From: Dimitrios Apostolou <jimis@gmx.net>
X-X-Sender: jimis@localhost.localdomain
To: Arjan van de Ven <arjan@infradead.org>
cc: Wojciech Ploskonka <wploskonka@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Alex Chiang <achiang@hp.com>,
       Len Brown <lenb@kernel.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: High cpu temperature with 2.6.32, bisection shows commit 69d258
 (fwd)
In-Reply-To: <alpine.LNX.2.00.1002102245200.1675@localhost.localdomain>
Message-ID: <alpine.LNX.2.00.1002102340310.1675@localhost.localdomain>
References: <alpine.LNX.2.00.1001071941470.1363@localhost.localdomain> <20100108171513.GB22713@ldl.fc.hp.com> <20100109134352.3dedd4ea@infradead.org> <alpine.LNX.2.00.1001100155370.1325@localhost.localdomain> <20100109160836.26a344a9@infradead.org>
 <alpine.LNX.2.00.1001100226570.1325@localhost.localdomain> <20100109164240.43b21247@infradead.org> <alpine.LNX.2.00.1001100251210.1334@localhost.localdomain> <20100112160734.89ee6b11.akpm@linux-foundation.org> <20100112213205.7d74808a@infradead.org>
 <alpine.LNX.2.00.1002102245200.1675@localhost.localdomain>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53000000000000003
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Feb 2010, Dimitrios Apostolou wrote:
> Hi Arjan,

I have also added Wojo, the user that had the problem, to the CC list so 
you can ask him any details you might need.


Dimitris


>
> it seems that the changes inside processor module have bitten another user, 
> see relevant thread at archlinux bugtracker:
> http://bugs.archlinux.org/task/17771
>
> It can be summarised with the following quote:
>
>
> I've tested jimis's suggestion about booting with init=/bin/sh and later 
> modprobing next modules.
> I confirm that module called "processor" in any kernel26 2.6.32.* is a root 
> problem of high power consumption.
> Here's output of modprobing it:
>
> ACPI: SSDT 000000003f6d94fb 00238 (v01 PmRef Cpu0Ist 000003000 INTL 20050624)
> ACPI: SSDT 000000003f6d8e8c 005EA (v01 PmRef Cpu0Cst 000003001 INTL 20050624)
> Marking TSC unstable due to TSC halts in idle
> processor LNXCPU:00: registered as cooling_device0
> ACPI: SSDT 000000003f6d9733 000C8(v01 PmRef Cpu1Ist 000003000 INTL 20050624)
> ACPI: SSDT 00000000376d9476 00085 (v01 PmRef Cpu1Cst 000003000 INTL 20050624)
> Swtiching to clocksource hpet
> processor LNXCPU:01: registered as cooling_device1
>
>
>
> As I understand, in his case the C3 state is unstable and exits immediately. 
> I have asked him to post the dmidecode output so you can put him on the 
> exception list too. However I now believe that more and more users will be 
> facing the same problem, it's not something you find easily, especially on 
> desktop machines! What do you think?
>
>
> Thanks,
> Dimitris
>
>
>
