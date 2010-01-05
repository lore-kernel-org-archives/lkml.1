Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990Ab0AEJQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab0AEJQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 04:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674Ab0AEJQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 04:16:33 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:54638 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab0AEJQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 04:16:31 -0500
Date: Tue, 5 Jan 2010 20:16:28 +1100
From: Simon Horman <horms@verge.net.au>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Venkappa Mala <Venkappa.Mala@lntinfotech.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "rmk+lkml@arm.linux.org.uk" <rmk+lkml@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: Linux kernel crash dumps for ARM
Message-ID: <20100105091625.GA19871@verge.net.au>
References: <EB1A7C66AD0C92419BFFC785A947865A09EA8C9129@BLRINMSMBX01.bglrodc.lntinfotech.com>
 <m17hrx9lgo.fsf@fess.ebiederm.org>
 <20100105084850.GA27860@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105084850.GA27860@linux-sh.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 05:48:51PM +0900, Paul Mundt wrote:
> On Mon, Jan 04, 2010 at 09:20:23PM -0800, Eric W. Biederman wrote:
> > Venkappa Mala <Venkappa.Mala@lntinfotech.com> writes:
> > >
> > > 2) As per kexec supports, kexec-tool is required and this allows you to load directly
> > >    to a new kernel from the currently running one
> > >
> > >     As from my side, i am not able to find arm implementation support in kexec-tools/crash sources.
> > >
> > >    - is kexce-tool supported for ARM or not?
> > >
> It would be rather counterintuitive for the kernel to support kexec and
> the necessary userspace components not to.
> 
> The MAINTAINERS file says:
> 
> KEXEC
> M:      Eric Biederman <ebiederm@xmission.com>
> W:      http://ftp.kernel.org/pub/linux/kernel/people/horms/kexec-tools/
> L:      kexec@lists.infradead.org
> S:      Maintained
> F:      include/linux/kexec.h
> F:      kernel/kexec.c
> 
> While the above URL redirects to gitweb, resulting in:
> 
> http://git.kernel.org/?p=linux/kernel/git/horms/kexec-tools.git;a=summary
> 
> A peripheral grep of the kexec-tools source results in:
> 
> $ git grep kdump | grep arm
> kexec/arch/arm/kexec-arm.c:     return 0; /* kdump is not supported on this platform (yet) */
> 
> So one could infer that kexec is supported on ARM whilst kdump is not.
> Adding crashdump support requires both some kernel and kexec-tools glue,
> but is fairly straightforward, just look at the other ports.

To add to this, my understanding is that kexec support varies across
different ARM platforms - that is to say, it works on some and fails on
others. While this seems to be slowly improving, I'm also aware of any list
of what is supported and what isn't.

