Return-Path: <linux-kernel-owner+w=401wt.eu-S1763558AbXFRRm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763558AbXFRRm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 13:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756150AbXFRRmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 13:42:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbXFRRmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 13:42:18 -0400
Message-ID: <4676C3F5.5070501@redhat.com>
Date: Mon, 18 Jun 2007 13:42:13 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Carlo Wood <carlo@alinoe.com>, Dave Airlie <airlied@gmail.com>,
       Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net
Subject: Re: [AGPGART] intel_agp: use table for device probe
References: <20070617195901.GA5689@alinoe.com> <20070617204904.GB3430@redhat.com> <20070617211338.GA24771@alinoe.com> <20070617213355.GC3430@redhat.com> <20070617223649.GA31587@alinoe.com> <20070617224918.GC12483@redhat.com> <20070618000643.GA1375@alinoe.com> <20070618001627.GA18598@redhat.com> <21d7e9970706171757n4709383cv7a39a66103edc370@mail.gmail.com> <20070618015636.GA8561@alinoe.com> <20070618023726.GA7594@zhen-devel.sh.intel.com>
In-Reply-To: <20070618023726.GA7594@zhen-devel.sh.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2007 10:37 PM, Wang Zhenyu wrote:
> On 2007.06.18 03:56:36 +0000, Carlo Wood wrote:
>> On Mon, Jun 18, 2007 at 10:57:38AM +1000, Dave Airlie wrote:
>>>> Right now, I'm at a loss to explain the corruption, so it's
>>>> difficult to suggest what to try.
>>> The thing is here, this is PCIE, so if there is a GPU plugged into the
>>> PCIE 16x slot in theory the main onboard graphics should disable, AGP
>>> code is used to control the GART for the onboard chip, in this case a
>>> plugged in card will  not use AGP, I wonder have Intel tested with a
>>> pcie card in place...
> 
> Agree. We seem to always enable AGP even IGD is disabled or not exists,
> other card should not depend on this module ever.
> 
>> That is Chinese for me :/.
>> Do you want me to try something?
> 
> Carlo, I've just built latest kernel git tree on a Dell 965G box and
> have a NV card plugged-in. It boots fine.
> 
> Linux agpgart interface v0.102 (c) Dave Jones
> agpgart: Detected an Intel 965G Chipset.
> agpgart: AGP aperture is 256M @ 0x0
> 
> I don't know why it hangs your machine when loading this module, it should
> just not bother anything. But from your last "modprobe: ..." line, it seems
> there's really badness somewhere, do you have serial console to see more
> in the message?

There are also these bug reports:

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=229913
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=242101
