Return-Path: <linux-kernel-owner+w=401wt.eu-S932179AbZD3OLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179AbZD3OLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 10:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932089AbZD3OLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 10:11:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52282 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088AbZD3OLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 10:11:37 -0400
Date: Thu, 30 Apr 2009 16:10:29 +0200
From: Nick Piggin <npiggin@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Sachin Sant <sachinp@in.ibm.com>,
       linuxppc-dev@ozlabs.org, linux-next@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: Next April 28: boot failure on PowerPC with SLQB
Message-ID: <20090430141029.GG6900@wotan.suse.de>
References: <49F938E4.2030703@in.ibm.com> <20090430064127.GF23746@wotan.suse.de> <49F973A0.8070106@in.ibm.com> <20090430103528.GA6900@wotan.suse.de> <1241087884.19252.5.camel@penberg-laptop> <20090430210004.05a61841.sfr@canb.auug.org.au> <20090430111825.GC6900@wotan.suse.de> <1241090429.19252.7.camel@penberg-laptop> <20090430130542.GF6900@wotan.suse.de> <20090501000033.ecce9ed8.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501000033.ecce9ed8.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 12:00:33AM +1000, Stephen Rothwell wrote:
> Hi Nick,
> 
> On Thu, 30 Apr 2009 15:05:42 +0200 Nick Piggin <npiggin@suse.de> wrote:
> >
> > Hmm, this might do it. The following code now passes some stress testing
> > in a userspace harness wheras before it did not (and was obviously wrong).
> 
> Indeed that allows it to boot fine.  Thanks.
> 
> Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>

Great, thanks for reporting and testing. This one is especially
important because it is basically scribbling on random memory
:( Pekka, please apply.

Thanks,
Nick


