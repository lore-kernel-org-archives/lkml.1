Return-Path: <linux-kernel-owner+w=401wt.eu-S932560AbXBPR1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560AbXBPR1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 12:27:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932510AbXBPR1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 12:27:04 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:40259 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932483AbXBPR1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 12:27:01 -0500
Subject: Re: [Xen-devel] Re: [patch 12/21] Xen-paravirt: Allocate and free
	vmalloc areas
From: Hollis Blanchard <hollisb@us.ibm.com>
Reply-To: Hollis Blanchard <hollisb@us.ibm.com>
To: Keir Fraser <keir@xensource.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@muc.de>,
       Zachary Amsden <zach@vmware.com>, xen-devel@lists.xensource.com,
       virtualization@lists.osdl.org, linux-kernel@vger.kernel.org,
       Jan Beulich <JBeulich@novell.com>, Chris Wright <chrisw@sous-sol.org>,
       Ian Pratt <ian.pratt@xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Jimi Xenidis <jimix@watson.ibm.com>
In-Reply-To: <C1FB9605.9988%keir@xensource.com>
References: <C1FB9605.9988%keir@xensource.com>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Fri, 16 Feb 2007 11:26:19 -0600
Message-Id: <1171646779.20683.5.camel@basalt>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-16 at 17:10 +0000, Keir Fraser wrote:
> 
> 
> On 16/2/07 16:46, "Jeremy Fitzhardinge" <jeremy@goop.org> wrote:
> 
> > Yes, that would work.  Unfortunately that's i386 arch-specific, whereas
> > the rest of this code is generic.  I guess I could just move it all to
> > arch/i386/mm.
> 
> This whole thing isn't an issue on ia64 (they no-op lock_vm_area) and
> powerpc doesn't use any of the Xen driver code at this time.

Not sure what you mean? PowerPC uses pretty much all of the Xen driver
code: event channels, blkfront/back, netfront/back, console, etc.

-- 
Hollis Blanchard
IBM Linux Technology Center

