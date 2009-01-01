Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbZAADNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbZAADNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 22:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZAADNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 22:13:04 -0500
Received: from ozlabs.org ([203.10.76.45]:59999 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450AbZAADND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 22:13:03 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC] cpualloc: improvements to per-cpu allocation
Date: Thu, 1 Jan 2009 13:42:58 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       catalin.marinas@arm.com, akpm@linux-foundation.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Stephen Rothwell <sfr@canb.auug.org.au>
References: <200812310938.09912.rusty@rustcorp.com.au> <200901011056.23443.rusty@rustcorp.com.au> <Pine.LNX.4.64.0812311902050.24421@quilx.com>
In-Reply-To: <Pine.LNX.4.64.0812311902050.24421@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901011342.58933.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 January 2009 11:33:00 Christoph Lameter wrote:
> On Thu, 1 Jan 2009, Rusty Russell wrote:
> 
> > I don't think it's a problem.  You still can't use them directly (this
> > wording was not meant to imply that), but you can now hand their addresses
> > to per_cpu_ptr() etc.  So zero-based x86-64 should Just Work.
> 
> Ok so this is going to be merged for 2.6.29? Its a good cleanup and a step
> forward to our goals.

I'm on the fence, but you've convinced me.  I'll put this in linux-next,
and if there's no damage, I'll push to Linus.  The actual conversions I'll
send via the maintainers though.

These patches have been around for a while, and though they've been polished
a little more in the last week or so the changes were mainly cosmetic.

Thanks,
Rusty.
