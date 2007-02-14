Return-Path: <linux-kernel-owner+w=401wt.eu-S1751197AbXBNFjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197AbXBNFjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 00:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbXBNFjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 00:39:44 -0500
Received: from ozlabs.org ([203.10.76.45]:55267 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbXBNFjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 00:39:44 -0500
Subject: Re: [Xen-devel] Re: [patch 13/21] Xen-paravirt: Add nosegneg
	capability to the vsyscall page notes
From: Rusty Russell <rusty@rustcorp.com.au>
To: Zachary Amsden <zach@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andrew Morton <akpm@osdl.org>,
       xen-devel@lists.xensource.com, Ian Pratt <ian.pratt@xensource.com>,
       virtualization@lists.osdl.org, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@muc.de>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
In-Reply-To: <45D23F97.5040907@vmware.com>
References: <20070213221729.772002682@goop.org>
	 <20070213221830.466651996@goop.org>  <45D23F97.5040907@vmware.com>
Content-Type: text/plain
Date: Wed, 14 Feb 2007 16:38:46 +1100
Message-Id: <1171431526.19842.108.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-13 at 14:45 -0800, Zachary Amsden wrote:
> Jeremy Fitzhardinge wrote:
> > Add the "nosegneg" fake capabilty to the vsyscall page notes. This is
> > used by the runtime linker to select a glibc version which then
> > disables negative-offset accesses to the thread-local segment via
> > %gs. These accesses require emulation in Xen (because segments are
> > truncated to protect the hypervisor address space) and avoiding them
> > provides a measurable performance boost.
> >   
> 
> I don't like this because now a kernel compiled with both CONFIG_XEN and 
> CONFIG_VMI has "nosegneg" turned on.  We don't actually require this for 
> performance or correctness, so it would be nice to be able to 
> dynamically turn it off instead of having it forced.

Ditto for lguest.

Rusty.


