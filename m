Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbZHSVFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbZHSVFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 17:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbZHSVFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 17:05:40 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56425 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbZHSVFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 17:05:39 -0400
Subject: Re: [Alacrityvm-devel] [PATCH v3 3/6] vbus: add a "vbus-proxy" bus
 model for vbus_driver objects
From: Hollis Blanchard <hollisb@us.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: "Ira W. Snyder" <iws@ovro.caltech.edu>,
       "Michael S. Tsirkin" <mst@redhat.com>,
       Gregory Haskins <gregory.haskins@gmail.com>, kvm@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net,
       Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>,
       Stefan Hajnoczi <stefanha@gmail.com>
In-Reply-To: <4A8C2A87.5060305@redhat.com>
References: <20090818172752.GC17631@ovro.caltech.edu>
	 <4A8AE918.5000109@redhat.com> <20090818182735.GD17631@ovro.caltech.edu>
	 <4A8AF880.6080704@redhat.com> <20090818205919.GA1168@ovro.caltech.edu>
	 <4A8B1C7F.4060008@redhat.com> <20090819003812.GA11168@ovro.caltech.edu>
	 <4A8B9051.3020505@redhat.com> <20090819152811.GA22294@ovro.caltech.edu>
	 <4A8C1C22.3010101@redhat.com> <20090819162902.GB22294@ovro.caltech.edu>
	 <4A8C2A87.5060305@redhat.com>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Wed, 19 Aug 2009 14:05:20 -0700
Message-Id: <1250715920.4237.26.camel@slab.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-19 at 19:38 +0300, Avi Kivity wrote:
> On 08/19/2009 07:29 PM, Ira W. Snyder wrote:
> >
> >    
> >> virtio-$yourhardware or maybe virtio-dma
> >>
> >>      
> > How about virtio-phys?
> >    
> 
> Could work.
> 
> > Arnd and BenH are both looking at PPC systems (similar to mine). Grant
> > Likely is looking at talking to an processor core running on an FPGA,
> > IIRC. Most of the code can be shared, very little should need to be
> > board-specific, I hope.
> >    
> 
> Excellent.
> 
> >>> That said, I'm not sure how qemu-system-ppc running on x86 could
> >>> possibly communicate using virtio-net. This would mean the guest is an
> >>> emulated big-endian PPC, while the host is a little-endian x86. I
> >>> haven't actually tested this situation, so perhaps I am wrong.
> >>>
> >>>        
> >> I'm confused now.  You don't actually have any guest, do you, so why
> >> would you run qemu at all?
> >>
> >>      
> > I do not run qemu. I am just stating a problem with virtio-net that I
> > noticed. This is just so someone more knowledgeable can be aware of the
> > problem.
> >
> >    
> 
> Ah, it certainly doesn't byteswap.  Maybe nobody tried it.  Hollis?

I've never tried it. I've only used virtio with matching guest/host
architectures.

-- 
Hollis Blanchard
IBM Linux Technology Center

