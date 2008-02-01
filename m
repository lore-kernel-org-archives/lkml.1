Return-Path: <linux-kernel-owner+w=401wt.eu-S934789AbYBABhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934789AbYBABhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 20:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbYBABhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 20:37:38 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45356 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965081AbYBABhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 20:37:24 -0500
Date: Thu, 31 Jan 2008 17:37:21 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [PATCH] mmu notifiers #v5
In-Reply-To: <20080131232842.GQ7185@v2.random>
Message-ID: <Pine.LNX.4.64.0801311733140.24297@schroedinger.engr.sgi.com>
References: <20080131045750.855008281@sgi.com> <20080131171806.GN7185@v2.random>
 <Pine.LNX.4.64.0801311207540.25477@schroedinger.engr.sgi.com>
 <20080131232842.GQ7185@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2008, Andrea Arcangeli wrote:

> I appreciate the review! I hope my entirely bug free and
> strightforward #v5 will strongly increase the probability of getting
> this in sooner than later. If something else it shows the approach I
> prefer to cover GRU/KVM 100%, leaving the overkill mutex locking
> requirements only to the mmu notifier users that can't deal with the
> scalar and finegrined and already-taken/trashed PT lock.

Mutex locking? Could you be more specific?

I hope you will continue to do reviews of the other mmu notifier patchset?


