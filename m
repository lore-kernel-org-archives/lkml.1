Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbXEIMGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbXEIMGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbXEIMGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:06:00 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45157 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbXEIMF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:05:58 -0400
Date: Wed, 9 May 2007 17:35:59 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
To: Paul Mackerras <paulus@samba.org>
Cc: suparna@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       xfs@oss.sgi.com, cmm@us.ibm.com
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and powerpc
Message-ID: <20070509120559.GA19430@amitarora.in.ibm.com>
References: <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426180332.GA7209@amitarora.in.ibm.com> <20070503212955.b1b6443c.akpm@linux-foundation.org> <17978.47502.786970.196554@cargo.ozlabs.ibm.com> <20070509101507.GA26056@in.ibm.com> <17985.42884.971318.859402@cargo.ozlabs.ibm.com> <20070509111011.GA21619@in.ibm.com> <17985.45682.284634.969153@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17985.45682.284634.969153@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 09:37:22PM +1000, Paul Mackerras wrote:
> Suparna Bhattacharya writes:
> 
> > > Of course the interface used by an application program would have the
> > > fd first.  Glibc can do the translation.
> > 
> > I think that was understood.
> 
> OK, then what does it matter what the glibc/kernel interface is, as
> long as it works?
> 
> It's only a minor point; the order of arguments can vary between
> architectures if necessary, but it's nicer if they don't have to.
> 32-bit powerpc will need to have the two int arguments adjacent in
> order to avoid using more than 6 argument registers at the user/kernel
> boundary, and s390 will need to avoid having a 64-bit argument last
> (if I understand it correctly).

You are right to say that. But, it may not be _that_ a minor point,
especially for the arch which is getting affected. It has
other implications like what Heiko noticed in his post below:
http://lkml.org/lkml/2007/4/27/377
 - implications like modifying glibc and *trace utilities for a particular
arch.

--
Regards,
Amit Arora
