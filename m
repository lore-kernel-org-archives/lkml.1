Return-Path: <linux-kernel-owner+w=401wt.eu-S1758587AbZHRKLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587AbZHRKLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 06:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758534AbZHRKLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 06:11:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60964 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755110AbZHRKL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 06:11:29 -0400
Date: Tue, 18 Aug 2009 13:09:45 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Gregory Haskins <gregory.haskins@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH v3 3/6] vbus: add a "vbus-proxy" bus model for
	vbus_driver objects
Message-ID: <20090818100945.GD13878@redhat.com>
References: <20090814154125.26116.70709.stgit@dev.haskins.net> <20090814154308.26116.46980.stgit@dev.haskins.net> <20090815103243.GA26749@elte.hu> <4A8954F0.3040402@gmail.com> <20090817142506.GB3602@elte.hu> <4A8971A8.2040102@gmail.com> <20090817150844.GA3307@elte.hu> <4A89B08A.4010103@gmail.com> <20090818095313.GC13878@redhat.com> <4A8A7BB9.2020906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8A7BB9.2020906@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 01:00:25PM +0300, Avi Kivity wrote:
> On 08/18/2009 12:53 PM, Michael S. Tsirkin wrote:
>> I'm not hung up on PCI, myself.  An idea that might help you get Avi
>> on-board: do setup in userspace, over PCI.  Negotiate hypercall support
>> (e.g.  with a PCI capability) and then switch to that for fastpath. Hmm?
>>    
>
> Hypercalls don't nest well.  When a nested guest issues a hypercall, you  
> have to assume it is destined to the enclosing guest, so you can't  
> assign a hypercall-capable device to a nested guest.
> 
> mmio and pio don't have this problem since the host can use the address  
> to locate the destination.

So userspace could map hypercall to address during setup and tell the
host kernel?

> -- 
> error compiling committee.c: too many arguments to function
