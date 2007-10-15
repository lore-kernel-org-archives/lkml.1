Return-Path: <linux-kernel-owner+w=401wt.eu-S1762799AbXJOXtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762799AbXJOXtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 19:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755591AbXJOXtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 19:49:07 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:37061 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755602AbXJOXtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 19:49:05 -0400
Subject: Re: [stable] [PATCH 00/12] xen/paravirt_ops patches for 2.6.24
From: Zachary Amsden <zach@vmware.com>
To: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
       Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       Stable Kernel <stable@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Keir Fraser <keir@xensource.com>
In-Reply-To: <200710160003.13189.ak@suse.de>
References: <20071015204840.074767068@goop.org>
	 <20071015215406.GA1588@kroah.com> <4713E2D6.90801@goop.org>
	 <200710160003.13189.ak@suse.de>
Content-Type: text/plain
Date: Mon, 15 Oct 2007 16:48:44 -0700
Message-Id: <1192492124.17375.62.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-16 at 00:03 +0200, Andi Kleen wrote:
> > Subject: [PATCH 12/12] xfs: eagerly remove vmap mappings to avoid
> > upsetting Xen
> 
> This should be probably done unconditionally because it's a undefined
> dangerous condition everywhere.

Should be done unconditionally.  One could remap the underlying physical
space to include an MMIO region, and speculative reads from the
cacheable virtual mapping of that region could move the robot arm,
destroying the world.

Zach

