Return-Path: <linux-kernel-owner+w=401wt.eu-S1764987AbXFRT67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764987AbXFRT67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 15:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759743AbXFRT6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 15:58:52 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:27340 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758872AbXFRT6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 15:58:52 -0400
Date: Mon, 18 Jun 2007 21:58:49 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Dave Airlie <airlied@gmail.com>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org, eric@anholt.net
Subject: Re: [AGPGART] intel_agp: use table for device probe
Message-ID: <20070618195849.GB7481@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Dave Airlie <airlied@gmail.com>, Dave Jones <davej@redhat.com>,
	linux-kernel@vger.kernel.org, eric@anholt.net
References: <20070617204904.GB3430@redhat.com> <20070617211338.GA24771@alinoe.com> <20070617213355.GC3430@redhat.com> <20070617223649.GA31587@alinoe.com> <20070617224918.GC12483@redhat.com> <20070618000643.GA1375@alinoe.com> <20070618001627.GA18598@redhat.com> <21d7e9970706171757n4709383cv7a39a66103edc370@mail.gmail.com> <20070618015636.GA8561@alinoe.com> <20070618023726.GA7594@zhen-devel.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618023726.GA7594@zhen-devel.sh.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 10:37:26AM +0800, Wang Zhenyu wrote:
> Carlo, I've just built latest kernel git tree on a Dell 965G box and
> have a NV card plugged-in. It boots fine.

It would be nice if you could test it with the exact same
hardware ... I am pretty sure it should be reproducable then *cough*

> Linux agpgart interface v0.102 (c) Dave Jones
> agpgart: Detected an Intel 965G Chipset.
> agpgart: AGP aperture is 256M @ 0x0
> 
> I don't know why it hangs your machine when loading this module, it should
> just not bother anything. But from your last "modprobe: ..." line, it seems
> there's really badness somewhere, do you have serial console to see more
> in the message?

The reason I react a bit late to your post is because in the meantime
I set up a serial console and figured out how to boot that way... and
captured the boot messages.

I will add that to one of the other posts, because as a result of
what they posted there I added agp=off - and that (indeed) makes it
possible for me to boot. Please see my next post thus.

-- 
Carlo Wood <carlo@alinoe.com>
