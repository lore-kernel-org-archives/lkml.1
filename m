Return-Path: <linux-kernel-owner+w=401wt.eu-S1761733AbYDQOhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761733AbYDQOhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 10:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756101AbYDQOhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 10:37:45 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39559 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756077AbYDQOho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 10:37:44 -0400
Date: Thu, 17 Apr 2008 09:37:38 -0500
From: Ryan Harper <ryanh@us.ibm.com>
To: Anthony Liguori <aliguori@us.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ryan Harper <ryanh@us.ibm.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm-devel@lists.sourceforge.net, Hollis Blanchard <hollisb@us.ibm.com>
Subject: Re: [PATCH] add virtio disk geometry feature
Message-ID: <20080417143738.GE17938@us.ibm.com>
References: <1208372197-20815-1-git-send-email-ryanh@us.ibm.com> <200804170715.55041.rusty@rustcorp.com.au> <4806706E.10701@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4806706E.10701@us.ibm.com>
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Anthony Liguori <aliguori@us.ibm.com> [2008-04-16 16:33]:
> Rusty Russell wrote:
> >On Thursday 17 April 2008 04:56:37 Ryan Harper wrote:
> >  
> >>From: Ryan Harper <ryanh@us.ibm.com>
> >>
> >>Rather than faking up some geometry, allow the backend to push the disk
> >>geometry via virtio pci config option.  Keep the old geo code around for
> >>compatibility.
> >>    
> >
> >Hi Ryan,
> >
> >   Looks good! Some brief review below.  Mainly just "how I would have done
> >things" stuff.  BTW, does this help in real life?  I assume something in
> >userspace wants it?
> >  
> 
> Boot loaders (like grub) query the geometry from the kernel to figure 
> out how to setup the stage1/stage2.  We've seen strange issues with grub 
> thinking it has crazy geometries when installed on a virtio disk (as 
> opposed to booting from virtio with an existing disk).
> 
> Ryan: have you tested a hardy install with your patches?  Does it help 
> when installing to virtio?  I could pretty reliably reproduce the 
> strangeness with a 20GB disk image FWIW.

I had tested out hardy with a 10G disk and saw nothing out of the
ordinary.  Disk size was the expected value and grub had no issues with
it.

-- 
Ryan Harper
Software Engineer; Linux Technology Center
IBM Corp., Austin, Tx
(512) 838-9253   T/L: 678-9253
ryanh@us.ibm.com
