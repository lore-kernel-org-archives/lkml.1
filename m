Return-Path: <linux-kernel-owner+w=401wt.eu-S1762916AbXJOWAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762916AbXJOWAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 18:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761544AbXJOV7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 17:59:54 -0400
Received: from gw.goop.org ([64.81.55.164]:33092 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761471AbXJOV7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 17:59:53 -0400
Message-ID: <4713E2D6.90801@goop.org>
Date: Mon, 15 Oct 2007 14:59:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       xen-devel@lists.xensource.com, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Keir Fraser <keir@xensource.com>, Stable Kernel <stable@kernel.org>
Subject: Re: [stable] [PATCH 00/12] xen/paravirt_ops patches for 2.6.24
References: <20071015204840.074767068@goop.org> <20071015215406.GA1588@kroah.com>
In-Reply-To: <20071015215406.GA1588@kroah.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> Yeah, but you cc:ed all 12 patches to stable@.  The majority of which we
> don't want to take, right?  Which specific ones should stable@ care
> about?

Crap, sorry about that.  I'd just intended to send the overview and the
four patches, which have explicit CC: stable lines in the patch
descriptions.  They are:

Subject: [PATCH 06/12] xen: add batch completion callbacks
Subject: [PATCH 07/12] xen: deal with stale cr3 values when unpinning
pagetables
Subject: [PATCH 10/12] xen: fix incorrect vcpu_register_vcpu_info
hypercall argument
Subject: [PATCH 12/12] xfs: eagerly remove vmap mappings to avoid
upsetting Xen

    J
