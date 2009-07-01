Return-Path: <linux-kernel-owner+w=401wt.eu-S1753730AbZGAO65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbZGAO65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 10:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbZGAO6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 10:58:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51655 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbZGAO6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 10:58:50 -0400
Date: Wed, 1 Jul 2009 07:58:36 -0700
From: Greg KH <gregkh@suse.de>
To: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
       Stefan Lippers-Hollmann <s.L-H@gmx.de>, linux-kernel@vger.kernel.org,
       ying.huang@intel.com, stable@kernel.org
Subject: Re: patch kvm-add-vt-x-machine-check-support.patch added to
 2.6.30-stable tree
Message-ID: <20090701145836.GA8480@suse.de>
References: <20090629184144.76C9948FD3@coco.kroah.org>
 <200907010053.40900.s.L-H@gmx.de>
 <20090630234206.GA22546@suse.de>
 <4A4B0BB1.2010102@linux.intel.com>
 <4A4B11A6.6080402@redhat.com>
 <87d48kiliq.fsf@basil.nowhere.org>
 <4A4B67A2.9090300@redhat.com>
 <20090701141845.GW6760@one.firstfloor.org>
 <4A4B76F3.6070604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4B76F3.6070604@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 05:47:15PM +0300, Avi Kivity wrote:
> On 07/01/2009 05:18 PM, Andi Kleen wrote:
> > On Wed, Jul 01, 2009 at 04:41:54PM +0300, Avi Kivity wrote:
> >    
> >> Should be in struct vmx_vcpu; otherwise ack.
> >>      
> >
> > Done
> >
> > ---
> >
> > KVM: Add VT-x machine check support v4
> >
> > VT-x needs an explicit MC vector intercept to handle machine checks in the
> > hypervisor.
> >
> > It also has a special option to catch machine checks that happen
> > during VT entry.
> >
> > Do these interceptions and forward them to the Linux machine check
> > handler. Make it always look like user space is interrupted because
> > the machine check handler treats kernel/user space differently.
> >
> > Thanks to Huang Ying and Jiang Yunhong for help and testing.
> >
> >    
> 
> Ack, thanks.  Stable boys, please use this instead of the patch from 
> mainline and the two patches it dragged in.

So, I should use this instead of:
	kvm-vmx-fix-handling-of-a-fault-during-nmi-unblocked-due-to-iret.patch
	kvm-move-exit-due-to-nmi-handling-into-vmx_complete_interrupts.patch
	kvm-add-vt-x-machine-check-support.patch

thanks,

greg k-h
