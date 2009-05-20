Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbZETJK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbZETJK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 05:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754744AbZETJKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 05:10:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53302 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525AbZETJKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 05:10:16 -0400
Subject: Re: [PATCH][KVM][retry 3] Add support for Pause Filtering to AMD
 SVM
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Mark Langsdorf <mark.langsdorf@amd.com>,
       Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4A13C7B0.10507@redhat.com>
References: <200905050909.58583.mark.langsdorf@amd.com>
	 <200905071000.14038.mark.langsdorf@amd.com>
	 <200905081203.55484.mark.langsdorf@amd.com>
	 <200905191356.37071.mark.langsdorf@amd.com>
	 <1242806386.26820.549.camel@twins>  <4A13C199.5020400@redhat.com>
	 <1242808954.26820.556.camel@twins>  <4A13C40B.8080608@redhat.com>
	 <1242809657.26820.559.camel@twins>  <4A13C7B0.10507@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 20 May 2009 11:10:16 +0200
Message-Id: <1242810616.26820.562.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-20 at 12:04 +0300, Avi Kivity wrote:
> Peter Zijlstra wrote:

> >> It's a fully virtualized guest.  There's no way to get this without 
> >> patching the guest kernel.
> >>     
> >
> > Yes there is.. virtualized monitor-wait stuff coupled with a
> > monitor-wait based spinlock implementation.
> >   
> 
> That only works if the guest uses monitor/mwait.  Not all of the guests 
> are under our control.  I don't know whether Windows uses 
> monitor/mwait.  Further, we don't have timed exits on mwait like we do 
> with pause.

Ugh, you really care about crap like windows?

> I've also heard that monitor/mwait are very slow and only usable on idle 
> loop stuff.

Yeah, current implementations suck, doesn't mean it has to stay that
way.

> > Once we go change silicon, you might as well do it right.
> >   
> 
> None of the major x86 vendors are under my control.

I thought this patch came from AMD, who changed their silicon so 'solve'
one of these virt problems.

/me goes hide again, and pretend all of virt doesn't exist :-) Think
happy thoughts.
