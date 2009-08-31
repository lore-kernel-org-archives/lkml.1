Return-Path: <linux-kernel-owner+w=401wt.eu-S1751671AbZHaOD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671AbZHaOD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 10:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbZHaOD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 10:03:26 -0400
Received: from [85.4.5.14] ([85.4.5.14]:61102 "ehlo gmx.net"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751012AbZHaODZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 10:03:25 -0400
X-Greylist: delayed 650 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Aug 2009 10:02:56 EDT
Message-ID: <4A9BCCF1.50102@gmx.net>
Date: Mon, 31 Aug 2009 15:15:29 +0200
From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081213 SUSE/1.1.14-1.1 SeaMonkey/1.1.14
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Grant Grundler <grundler@parisc-linux.org>, Ray Lee <ray-lk@madrabbit.org>,
       torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Faidon Liambotis <paravoid@debian.org>,
       Matt Domsch <Matt_Domsch@dell.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] intel-iommu: Work around yet another BIOS bug
References: <bug-14003-10286@http.bugzilla.kernel.org/>  <20090819142634.0fc550d1.akpm@linux-foundation.org>  <1250754748.8974.17.camel@macbook.infradead.org>  <1250755318.8974.26.camel@macbook.infradead.org>  <2c0942db0908201229o6ba670ebqda4d7cfc72d0ece8@mail.gmail <1250805298.3311.62.camel@macbook.infradead.org>
In-Reply-To: <1250805298.3311.62.camel@macbook.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.08.2009 23:54, David Woodhouse wrote:
> On Thu, 2009-08-20 at 15:47 -0600, Grant Grundler wrote:
>   
>> I'm more inclined to believe it's sloppiness on the part of the BIOS
>> writers but thought this might be an alternative explanation.
>>     
>
> Nah, this is just the normal story: "We smoked too much crack and fried
> our brains, and we don't do any QA on the crap we write because that
> would leave fewer hours in the day for us to service our crack habit".
>
> We _really_ need open source firmware.
>
> Or at _least_ firmware written by competent engineers -- but I think
> we've all fairly much given up on that happening by now?
>   

coreboot is an open source (GPLv2) x86 lightweight firmware written in C
(with optional BIOS and EFI compatibility modules if anyone cares).
While it does not support all current x86 chipsets, it still does
support quite a few mainboards.
The developers are friendly and try to fix any reported bugs. There are
two big obstacles until x86 world domination, though: A dozen core
developers are simply not enough for the huge task (there are more open
specs than developers can keep up with), and some chipset vendors don't
open their specs. Anyone interested is invited to contribute and make
the world a better place.

Oh, and it supports packing a Linux kernel in the mainboard flash ROM
for diskless/networkless booting (that coreboot+Linux combination was
called LinuxBIOS some time ago).

More information at http://www.coreboot.org/


Regards,
Carl-Daniel
