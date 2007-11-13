Return-Path: <linux-kernel-owner+w=401wt.eu-S1761239AbXKMXh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761239AbXKMXh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 18:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756406AbXKMXhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 18:37:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43490 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895AbXKMXhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 18:37:08 -0500
Date: Tue, 13 Nov 2007 15:22:58 -0800
From: Greg KH <greg@kroah.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       xen-devel@lists.xensource.com, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Keir Fraser <keir@xensource.com>, Stable Kernel <stable@kernel.org>
Subject: Re: [stable] [PATCH 00/12] xen/paravirt_ops patches for 2.6.24
Message-ID: <20071113232258.GA10338@kroah.com>
References: <20071015204840.074767068@goop.org> <20071015215406.GA1588@kroah.com> <4713E2D6.90801@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4713E2D6.90801@goop.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 02:59:50PM -0700, Jeremy Fitzhardinge wrote:
> Greg KH wrote:
> > Yeah, but you cc:ed all 12 patches to stable@.  The majority of which we
> > don't want to take, right?  Which specific ones should stable@ care
> > about?
> 
> Crap, sorry about that.  I'd just intended to send the overview and the
> four patches, which have explicit CC: stable lines in the patch
> descriptions.  They are:
> 
> Subject: [PATCH 06/12] xen: add batch completion callbacks
> Subject: [PATCH 07/12] xen: deal with stale cr3 values when unpinning
> pagetables
> Subject: [PATCH 10/12] xen: fix incorrect vcpu_register_vcpu_info
> hypercall argument
> Subject: [PATCH 12/12] xfs: eagerly remove vmap mappings to avoid
> upsetting Xen

These don't apply now due to the x86 merge.  Care to backport them and
send them to the stable@kernel.org address so we can apply them
properly?

thanks,

greg k-h
