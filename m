Return-Path: <linux-kernel-owner+w=401wt.eu-S1756357AbYAOBeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbYAOBeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 20:34:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbYAOBeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 20:34:16 -0500
Received: from koto.vergenet.net ([210.128.90.7]:42096 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbYAOBeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 20:34:15 -0500
Date: Tue, 15 Jan 2008 10:34:10 +0900
From: Simon Horman <horms@verge.net.au>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH -mm 1/2] kexec/i386: kexec page table code clean up -
	add arch_kimage
Message-ID: <20080115013409.GB7969@verge.net.au>
References: <1199847467.8126.15.camel@caritas-dev.intel.com> <20080110011423.GB23143@redhat.com> <20080110081535.GA30505@verge.net.au> <1200317376.11020.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200317376.11020.9.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 01:29:36PM +0000, Ian Campbell wrote:
> 
> On Thu, 2008-01-10 at 17:15 +0900, Simon Horman wrote: 
> > > Have you tested Xen too? Does it run into issues with this change?
> > 
> > Xen will need to be updated for this change but it shouldn't be a big
> > deal. Basically right now it calls __ma() (which is kind of like __pa())
> > on kexec_pgd and friends. Updating the arguments to __ma() to use
> > the new arch_kimage pointers should be easy enough.
> 
> I think you mean the Xen specific parts of the kexec machinery in the
> kernel.c would need updating rather than the hypervisor, right?

Yes, that is right. Sorry for the confusion.

> I don't think these changes will cause anything more than minor problems
> for whoever ports the Xen kexec stuff upstream.
> 
> > N.B: As this is Dom0 code (not DomU) it is maintained in the xen
> > repository and has been merged into Linux.
> 
> I don't think we would bother backporting these changes to there, would
> we?

No, I was more thinking of the situation where Xen moves its kernel forwards.

-- 
Horms

