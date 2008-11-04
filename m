Return-Path: <linux-kernel-owner+w=401wt.eu-S1753627AbYKDCiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbYKDCiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 21:38:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbYKDCim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 21:38:42 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:55910 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbYKDCil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 21:38:41 -0500
Date: Tue, 4 Nov 2008 02:38:37 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: linux-pci@vger.kernel.org, kristen.c.accardi@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add option to passively listen for PCIE hotplug events
Message-ID: <20081104023837.GA12165@srcf.ucam.org>
References: <20081029200903.GA1678@srcf.ucam.org> <490FAC33.9050808@jp.fujitsu.com> <20081104020700.GA11761@srcf.ucam.org> <490FB397.8050809@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490FB397.8050809@jp.fujitsu.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2008 at 11:29:43AM +0900, Kenji Kaneshige wrote:
> Matthew Garrett wrote:
> >What do you mean by "not work properly"? The hardware we've tested with 
> >fires events even without an OSHP method being present. That's the case 
> >we're trying to deal with.
> >
> 
> Because the explanation of PCI Express Native Hot Plug control bit in
> _OSC return value in PCI firmware spec says
> 
> "... If firmware allows the operating system control of this feature,
> then in the context of the _OSC method, it must ensure that all hot
> plug events are routed to device interrupts as described in the PCI
> Express Base Specification. ..."
> 
> My understanding is that it is not ensured that all hot plug events
> are routed to device interrupts, if hotplug control is not granted.

My understanding is that in the worst case the hardware/firmware won't 
give us any events - that's basically equivalent to not having the 
driver loaded at all. On hardware that gives us the events anyway, we 
get some extra functionality.

Thanks for the feedback!
-- 
Matthew Garrett | mjg59@srcf.ucam.org
