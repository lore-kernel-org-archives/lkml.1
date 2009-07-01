Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbZGAR2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbZGAR2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 13:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbZGAR2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 13:28:40 -0400
Received: from kroah.org ([198.145.64.141]:55704 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753821AbZGAR2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 13:28:39 -0400
Date: Wed, 1 Jul 2009 10:27:17 -0700
From: Greg KH <greg@kroah.com>
To: Avi Kivity <avi@redhat.com>
Cc: Greg KH <gregkh@suse.de>, Andi Kleen <ak@linux.intel.com>,
       Stefan Lippers-Hollmann <s.L-H@gmx.de>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, ying.huang@intel.com,
       stable@kernel.org
Subject: Re: [stable] patch kvm-add-vt-x-machine-check-support.patch added
 to 2.6.30-stable tree
Message-ID: <20090701172717.GC15542@kroah.com>
References: <200907010053.40900.s.L-H@gmx.de>
 <20090630234206.GA22546@suse.de>
 <4A4B0BB1.2010102@linux.intel.com>
 <4A4B11A6.6080402@redhat.com>
 <87d48kiliq.fsf@basil.nowhere.org>
 <4A4B67A2.9090300@redhat.com>
 <20090701141845.GW6760@one.firstfloor.org>
 <4A4B76F3.6070604@redhat.com>
 <20090701145836.GA8480@suse.de>
 <4A4B7AF4.4070205@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4B7AF4.4070205@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 06:04:20PM +0300, Avi Kivity wrote:
> On 07/01/2009 05:58 PM, Greg KH wrote:
> >> Ack, thanks.  Stable boys, please use this instead of the patch from
> >> mainline and the two patches it dragged in.
> >>      
> >
> > So, I should use this instead of:
> > 	kvm-vmx-fix-handling-of-a-fault-during-nmi-unblocked-due-to-iret.patch
> > 	kvm-move-exit-due-to-nmi-handling-into-vmx_complete_interrupts.patch
> > 	kvm-add-vt-x-machine-check-support.patch
> >    
> 
> Exactly.  I'll run my regression tests on stable-queue and let you know 
> if I encounter any trouble.

Thanks, I've now done this, and will push out a 2.6.30.1-rc2 in a bit so
you can test with that as well.

greg k-h
