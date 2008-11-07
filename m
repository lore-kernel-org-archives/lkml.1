Return-Path: <linux-kernel-owner+w=401wt.eu-S1756264AbYKGGak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264AbYKGGak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 01:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755693AbYKGG2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 01:28:48 -0500
Received: from kroah.org ([198.145.64.141]:48974 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755654AbYKGG2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 01:28:41 -0500
Date: Thu, 6 Nov 2008 22:19:52 -0800
From: Greg KH <greg@kroah.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Anthony Liguori <anthony@codemonkey.ws>,
       "Fischer, Anna" <anna.fischer@hp.com>, H L <swdevyid@yahoo.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "Chiang, Alexander" <achiang@hp.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
Message-ID: <20081107061952.GF3860@kroah.com>
References: <20081106154351.GA30459@kroah.com> <894107.30288.qm@web45108.mail.sp1.yahoo.com> <20081106164919.GA4099@kroah.com> <0199E0D51A61344794750DC57738F58E5E26F996C4@GVW1118EXC.americas.hpqcorp.net> <20081106183630.GD11773@parisc-linux.org> <491371F0.7020805@codemonkey.ws> <20081106225854.GA15439@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106225854.GA15439@parisc-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 03:58:54PM -0700, Matthew Wilcox wrote:
> > What we would rather do in KVM, is have the VFs appear in the host as 
> > standard network devices.  We would then like to back our existing PV 
> > driver to this VF directly bypassing the host networking stack.  A key 
> > feature here is being able to fill the VF's receive queue with guest 
> > memory instead of host kernel memory so that you can get zero-copy 
> > receive traffic.  This will perform just as well as doing passthrough 
> > (at least) and avoid all that ugliness of dealing with SR-IOV in the guest.
> 
> This argues for ignoring the SR-IOV mess completely.  Just have the
> host driver expose multiple 'ethN' devices.

That would work, but do we want to do that for every different type of
driver?

thanks,

greg k-h
