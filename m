Return-Path: <linux-kernel-owner+w=401wt.eu-S933044AbXBLGvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044AbXBLGvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 01:51:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933048AbXBLGvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 01:51:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47656 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933044AbXBLGvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 01:51:07 -0500
From: Andi Kleen <ak@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: remote debugging via FireWire
Date: Mon, 12 Feb 2007 07:49:54 +0100
User-Agent: KMail/1.9.5
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Bernhard Kaindl <bk@suse.de>,
       discuss@x86-64.org, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
References: <200702101242.48467.ak@suse.de> <45CE19F3.2070603@s5r6.in-berlin.de> <1171229738.20494.60.camel@localhost.localdomain>
In-Reply-To: <1171229738.20494.60.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702120749.54976.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 February 2007 22:35, Benjamin Herrenschmidt wrote:

> I'd like to have that on ppc as well, so I'd rather keep it in drivers/

This will need some abstraction at least -- there are some early mapping hacks
that are x86 specific right now.

> I agree that it doesn't need to be a module. If you can load modules,
> then you can load the full ohci driver. Thus, if it's an early thingy
> initialized by arch, it can export a special "takeover" hook that the
> proper ohci module can then call to override it (important if we start
> having an irq handler).
> 
> Andi, also, how do you deal with iommu ? Not at all ? :-)

Yes -- it's really early debugging hack mostly. It's reasonable to 
let the iommu be disabled (or later a special bypass can be added for this) 

-Andi
 
