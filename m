Return-Path: <linux-kernel-owner+w=401wt.eu-S933807AbXC1Wri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933807AbXC1Wri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 18:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934055AbXC1Wri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 18:47:38 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:44604 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933807AbXC1Wri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 18:47:38 -0400
Date: Wed, 28 Mar 2007 15:47:17 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Zachary Amsden <zach@vmware.com>
Cc: William Lee Irwin III <wli@holomorphy.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jeremy@goop.org
Subject: Re: [RFC] i386: Remove page sized slabs for pgds and pmds
Message-ID: <20070328224717.GK10574@sequoia.sous-sol.org>
References: <Pine.LNX.4.64.0703281309210.12985@schroedinger.engr.sgi.com> <20070328222656.GS6602@sequoia.sous-sol.org> <20070328223327.GG2986@holomorphy.com> <460AFD7F.6050802@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <460AFD7F.6050802@vmware.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Zachary Amsden (zach@vmware.com) wrote:
> William Lee Irwin III wrote:
> >>clone_pgd_range() for consistency?  and it seems we lost a
> >>paravirt_alloc_pd_clone() in there somewhere.
> >>    
> >
> >Yes, another reason why it shouldn't have been posted as-is. It was not
> >intended to for anything more than comparative benchmarking on systems
> >without graphics running on the bare metal as opposed to Xen/etc. guests.
> >  
> 
> So clone_pgd_range is mostly useless now.  Originally, I intended it to 
> take the part of paravirt_alloc_pd_clone.  We should probably merge the 
> two into just one function, unless someone thinks clone_pgd_range is 
> actually useful for something.

No, I was going to suggest just that.  It was orginially introduced as
the place holder for that IIRC.

thanks,
-chris
