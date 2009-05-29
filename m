Return-Path: <linux-kernel-owner+w=401wt.eu-S1752133AbZE2DxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbZE2DxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 23:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbZE2Dw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 23:52:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:47579 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbZE2Dw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 23:52:58 -0400
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mitch Bradley <wmb@firmworks.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <4A1F4189.8060702@firmworks.com>
References: <20090527175609.GB31861@flint.arm.linux.org.uk>
	 <1243496236.3171.140.camel@pasglop>
	 <20090528091513.GA14789@n2100.arm.linux.org.uk>
	 <20090528.025739.16559619.davem@davemloft.net>	<gvlvcs$ub5$1@ger.gmane.org>
	 <fa686aa40905280713u2b3ef5fvbe3d58ccdb629b60@mail.gmail.com>
	 <1243549318.17903.9.camel@pasglop> <20090529013908.GA7831@yookeroo.seuss>
	 <4A1F4189.8060702@firmworks.com>
Content-Type: text/plain
Date: Fri, 29 May 2009 13:52:16 +1000
Message-Id: <1243569136.17903.27.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-29 at 09:59 +0800, Mitch Bradley wrote:
> I have an embeddable FCode interpreter that could be built into a 
> kernel.  Perhaps it's time to resurrect that.  The total size is on the 
> order of 50K with debugging tools included; probably more like 35K if 
> stripped down to just the essentials.

It's interesting... might be an option. I tend to prefer myself having
the methods be properly documented by the HW designer, and implemented
as C code in the kernel, for various reasons.

There are pro and cons to both approaches. We could define special
properties to embed f-code in the device-tree and run it that way, it's
probably a more business-friendly method :-) IE. It makes it possible
to completely avoid board specific code in the kernel, possibly making
it feasible to run existing distributions on new HW to a certain
extend by just updating those scripts.

But it comes with some drawbacks too... too often, this stuff will
replace good documentation, the scripts provided by the FW will be
busted in subtle ways that the kernel will have to work around, and thus
it can be used as a way to avoid documenting or open sourcing things and
obfuscating operations.

So at this stage, my personal preference goes for well defined methods
named by the device tree and implemented by the kernel natively. But
people are free to disagree with me on this one.

Cheers,
Ben.


