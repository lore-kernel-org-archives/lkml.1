Return-Path: <linux-kernel-owner+w=401wt.eu-S1760368AbYBEU7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760368AbYBEU7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755394AbYBEU7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:59:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:51610 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbYBEU7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:59:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,309,1199692800"; 
   d="scan'208";a="256767163"
Message-ID: <47A8CE10.4010807@intel.com>
Date: Tue, 05 Feb 2008 12:58:56 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Arjan van de Ven <arjan@infradead.org>,
       ???????????? ?????????????????????? <penguinista@mail.net.mk>,
       Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>
Subject: Re: PCIE ASPM support hangs my laptop pretty often
References: <200802051840.05237.penguinista@mail.net.mk> <20080205104623.33c5f3e0@laptopd505.fenrus.org> <20080205185100.GA4633@kroah.com>
In-Reply-To: <20080205185100.GA4633@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Feb 2008 20:59:40.0861 (UTC) FILETIME=[06A026D0:01C8683A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Feb 05, 2008 at 10:46:23AM -0800, Arjan van de Ven wrote:
>> On Tue, 5 Feb 2008 18:40:04 +0100
>> ???????????? ??????????????????????  <penguinista@mail.net.mk> wrote:
>>
>>> I've patched my kernel with the PCIe ASPM and after setting
>>> echo powersave > /sys/module/pcie_aspm/parameters/policy
>>>
>>> I started to experience random hangs of my laptop.
>>> Hardware info:
>>> Thinkpad x60s 1704-5UG
>> the x60's chipset doesn't support ASPM properly afaik... bad idea.
> 
> Well, the code shouldn't then cause a crash of the machine :)

The user enabled it specifically (where it is disabled by default)

ASPM has been crashing e1000(e), which is why I've recently merged a patch to
disable L1 ASPM for the onboard 82573 nic on those platforms.

this new infrastructure should work in the default configuration - enabling ASPM
where this system leaves it disabled is expected to give problems unless you know
what you are doing.

Auke
